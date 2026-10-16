# ChaiNIEx on AWS — Step-by-Step Deployment Guide (Oregon, us-west-2)

> Method: **AWS Management Console** (website), with screenshots at each step for the presentation.
> Services used: **S3 · IAM · EC2 · Security Groups · Target Group · Application Load Balancer · Lambda · EventBridge · CloudWatch**

## Architecture

```
            Internet
               │  HTTP :80
     ┌─────────▼──────────┐
     │ Application Load    │  (public, spans us-west-2a + 2b)
     │ Balancer (ALB)      │
     └─────────┬──────────┘
               │ :4000   health check → /api/health
     ┌─────────▼──────────┐        pg_dump        ┌──────────────┐  ObjectCreated  ┌──────────────────────┐
     │ EC2 (t3.micro)      │ ────────────────────► │  S3 bucket    │ ──────────────► │ Lambda: backup-notifier│
     │ Node 20 + PM2       │   (via IAM Role)      │  backups/     │                 └──────────────────────┘
     │ PostgreSQL 16       │                       └──────────────┘
     └────────────────────┘
               ▲  GET /api/health every 5 min
     ┌─────────┴───────────────┐
     │ Lambda: health-check     │ ◄── EventBridge schedule
     └─────────────────────────┘          all logs → CloudWatch
```

---

## Step 0 — Select Region
Top-right of the console → **US West (Oregon) us-west-2**.
🗣️ *"I picked Oregon because it's one of AWS's cheapest regions and has every service I need."*

## Step 1 — S3 Bucket (backup storage)
1. **S3 → Create bucket**
2. Name: `chainex-backups-<yourname>` (names must be unique across all of AWS)
3. Region: us-west-2 · **Block all public access: ON** · Create.

🗣️ *"S3 is object storage. It stores the database backups, and the bucket stays private."*

## Step 2 — IAM Role for EC2
1. **IAM → Roles → Create role** → Trusted entity: **AWS service → EC2**
2. Attach policy **AmazonS3FullAccess** (or a narrower custom policy that only allows this bucket)
3. Name: `chainex-ec2-role` → Create.

🗣️ *"With an IAM role, the server can upload to S3 without any access keys stored on it. This follows the least-privilege principle."*

## Step 3 — Security Groups (firewalls)
**EC2 → Security Groups → Create**
| Name | Inbound rule | Source |
|---|---|---|
| `chainex-alb-sg` | HTTP 80 | 0.0.0.0/0 |
| `chainex-ec2-sg` | Custom TCP 4000 | **chainex-alb-sg** |
| `chainex-ec2-sg` | SSH 22 | My IP |

🗣️ *"The server can't be reached directly from the internet. Only the load balancer can talk to it on port 4000."*

## Step 4 — EC2 Instance
1. **EC2 → Launch instance**
2. Name `chainex-server` · AMI **Amazon Linux 2023** · Type **t3.micro** (Free Tier)
3. Key pair: create `chainex-key` (download the .pem file)
4. Network: default VPC, **auto-assign public IP: enabled**, security group **chainex-ec2-sg**
5. Advanced details → IAM instance profile: **chainex-ec2-role**
6. Advanced details → **User data**: paste all of [`deploy/ec2-setup.sh`](ec2-setup.sh). **First, edit `S3_BUCKET=` to match your bucket name.**
7. Launch, then wait about 5 minutes.

🗣️ *"EC2 is a virtual server. The User Data script automates the whole setup: it installs Node and PostgreSQL, loads the schema and seed data, and starts the app with PM2 so it restarts automatically after a crash or reboot."*

Optional check: `ssh -i chainex-key.pem ec2-user@<public-ip>` → `pm2 status` · `curl localhost:4000/api/health`

## Step 5 — Target Group
1. **EC2 → Target Groups → Create** → Type **Instances**
2. Name `chainex-tg` · Protocol HTTP · **Port 4000**
3. Health check path: **`/api/health`**
4. Register `chainex-server` → Include as pending → Create.

🗣️ *"The target group is the list of servers the load balancer can send traffic to. It also checks /api/health to make sure each one is healthy."*

## Step 6 — Application Load Balancer
1. **EC2 → Load Balancers → Create → Application Load Balancer**
2. Name `chainex-alb` · Internet-facing · IPv4
3. Mappings: select **at least 2 AZs** (us-west-2a, us-west-2b)
4. Security group: **chainex-alb-sg**
5. Listener HTTP:80 → forward to **chainex-tg** → Create.
6. Wait until the state is **Active** and the target group shows **healthy**.
7. Copy the **DNS name** → open `http://<ALB-DNS>/`, `/admin`, `/supplier`.

🗣️ *"The ALB is the single public entry point. It spreads traffic across servers, stops sending traffic to unhealthy ones, and lets us add more EC2 instances later without changing the URL."*

## Step 7 — Lambda #1: Health Check (scheduled)
1. **Lambda → Create function** → Author from scratch → `chainex-health-check` · Runtime **Node.js 20.x**
2. Paste [`lambda/health-check/index.mjs`](lambda/health-check/index.mjs) → **Deploy**
3. Configuration → Environment variables: `APP_URL` = `http://<ALB-DNS>`
4. Configuration → General → Timeout **10 s**
5. **Add trigger → EventBridge (CloudWatch Events)** → New rule `every-5-min` → Schedule expression `rate(5 minutes)`
6. Test → see `"status":"UP"`. Logs: **Monitor → View CloudWatch logs**.

🗣️ *"Lambda is serverless. AWS runs the code only when it's triggered, and we pay per call. This function monitors our site every 5 minutes."*

## Step 8 — Lambda #2: Backup Notifier (event-driven)
1. Create function `chainex-backup-notifier` · Node.js 20.x
2. Paste [`lambda/backup-notifier/index.mjs`](lambda/backup-notifier/index.mjs) → Deploy
3. **Add trigger → S3** → bucket `chainex-backups-…` · Event: **All object create events** · Prefix `backups/` → acknowledge → Add.

🗣️ *"Every time the server uploads a backup, S3 automatically triggers this Lambda. That's event-driven architecture."*

## Step 9 — Live Demo
1. Open `http://<ALB-DNS>/` → log in using the credentials in `login_details.md`.
2. SSH into EC2 → `~/chainiex-supply-chain/deploy/backup-to-s3.sh`
3. Show the new file in S3 → `backups/`
4. Show the CloudWatch logs for **backup-notifier** (📦 New backup) and **health-check** (UP).
5. Target group → healthy targets.

## Step 10 — Cleanup (avoid charges!)
Delete in this order: **ALB → Target group → EC2 instance → Lambdas + EventBridge rule → empty & delete the S3 bucket → IAM role → security groups**.

---

## Cost
| Service | Cost |
|---|---|
| EC2 t3.micro | Free Tier (750 h/month) |
| S3 | Free Tier (5 GB) |
| Lambda + EventBridge | Free Tier (1M requests) |
| **ALB** | **~$0.0225/h, about ₹45/day: not free** |

## Appendix — The Same Thing with the AWS CLI
```bash
aws configure                                   # region: us-west-2
aws s3 mb s3://chainex-backups-yourname --region us-west-2
aws ec2 run-instances --image-id <al2023-ami> --instance-type t3.micro \
  --key-name chainex-key --security-group-ids <ec2-sg> \
  --iam-instance-profile Name=chainex-ec2-role --user-data file://deploy/ec2-setup.sh
aws elbv2 create-target-group --name chainex-tg --protocol HTTP --port 4000 \
  --vpc-id <vpc> --health-check-path /api/health
aws elbv2 create-load-balancer --name chainex-alb --subnets <subnet-a> <subnet-b> \
  --security-groups <alb-sg>
aws elbv2 create-listener --load-balancer-arn <alb-arn> --protocol HTTP --port 80 \
  --default-actions Type=forward,TargetGroupArn=<tg-arn>
aws lambda create-function --function-name chainex-health-check --runtime nodejs20.x \
  --handler index.handler --zip-file fileb://health-check.zip --role <lambda-role-arn>
```
🗣️ *"I used the Console so I could show each step visually. The same infrastructure can be scripted with the CLI, or with Infrastructure-as-Code tools like CloudFormation or Terraform."*

## Likely Viva Questions
- **Why a load balancer with only one EC2?** It gives a stable public endpoint, health checks, and room to scale. We can add an Auto Scaling Group later without changing the URL.
- **Why not RDS?** To stay within Free Tier and keep things simple. RDS would add managed backups and Multi-AZ failover.
- **Lambda vs EC2?** EC2 runs all the time (the stateful app plus the DB). Lambda runs only when triggered, for short tasks.
- **How is it secured?** Private S3 bucket, IAM role instead of access keys, EC2 reachable only through the ALB, bcrypt password hashes, JWT authentication.
- **What about HTTPS?** Get a free certificate from ACM, add an HTTPS:443 listener on the ALB, and redirect port 80 to 443 (this needs a domain).

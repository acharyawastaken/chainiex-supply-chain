# ChaiNIEx on AWS — Step-by-Step Deployment Guide (Oregon, us-west-2)

> Method: **AWS Management Console** (website). Take a screenshot at each step for the presentation.
> Services: **S3 · IAM · EC2 · Security Group · Lambda · EventBridge · CloudWatch**, all on the **Free Tier**.

## Architecture

```
            Internet
               │  HTTP :80
     ┌─────────▼──────────┐        pg_dump        ┌──────────────┐  ObjectCreated  ┌────────────────────────┐
     │ EC2 (t3.micro)      │ ────────────────────► │  S3 bucket    │ ──────────────► │ Lambda: backup-notifier │
     │ :80 → :4000         │   (via IAM Role)      │  backups/     │                 └────────────────────────┘
     │ Node 20 + PM2       │                       └──────────────┘
     │ PostgreSQL 16       │
     └────────────────────┘
               ▲  GET /api/health every 5 min
     ┌─────────┴───────────────┐
     │ Lambda: health-check     │ ◄── EventBridge schedule
     └─────────────────────────┘          all logs → CloudWatch
```

---

## Step 0 — Select Region
Top-right of the console → **US West (Oregon) us-west-2**.
🗣️ *"I picked Oregon because it's one of AWS's lowest-cost regions and has every service I need."*

## Step 1 — S3 Bucket (backup storage)
1. **S3 → Create bucket**
2. Name: `chainex-backups-<yourname>` (names must be unique across all of AWS)
3. Region: us-west-2 · **Block all public access: ON** · Create.

🗣️ *"S3 is object storage. It stores the database backups, and the bucket stays private."*

## Step 2 — IAM Role for EC2
1. **IAM → Roles → Create role** → Trusted entity: **AWS service → EC2**
2. Attach policy **AmazonS3FullAccess**
3. Name: `chainex-ec2-role` → Create.

🗣️ *"With an IAM role, the server can upload to S3 without any access keys stored on it."*

## Step 3 — Security Group (firewall)
**EC2 → Security Groups → Create** `chainex-ec2-sg`
| Type | Port | Source |
|---|---|---|
| HTTP | 80 | 0.0.0.0/0 (Anywhere) |
| SSH | 22 | My IP |

🗣️ *"Only web traffic and SSH from my own IP are allowed in. The database port 5432 is never exposed to the internet."*

## Step 4 — EC2 Instance
1. **EC2 → Launch instance**
2. Name `chainex-server` · AMI **Amazon Linux 2023** · Type **t3.micro** (Free Tier)
3. Key pair: create `chainex-key` (download the .pem file)
4. Network: default VPC · **Auto-assign public IP: Enable** · Security group **chainex-ec2-sg**
5. Advanced details → IAM instance profile: **chainex-ec2-role**
6. Advanced details → **User data**: paste all of [`deploy/ec2-setup.sh`](ec2-setup.sh). **First, edit `S3_BUCKET=` to match your bucket name.**
7. Launch, then wait about 5 minutes.
8. Copy the **Public IPv4 address** → open `http://<EC2-IP>/`, `/admin`, `/supplier`.

🗣️ *"EC2 is a virtual server. The User Data script automates the whole setup: it installs Node and PostgreSQL, loads the schema and seed data, starts the app with PM2 so it restarts automatically after a crash or reboot, and forwards port 80 to the app's port 4000."*

Troubleshooting: `ssh -i chainex-key.pem ec2-user@<EC2-IP>` → `pm2 status` · `curl localhost:4000/api/health` · `sudo cat /var/log/cloud-init-output.log`

### Step 4b — (Optional) Elastic IP
**EC2 → Elastic IPs → Allocate → Associate** with `chainex-server`.
🗣️ *"An Elastic IP is a fixed public address, so the URL doesn't change if the server restarts."*
⚠️ It's free only while attached to a running instance. **Release it during cleanup.**

## Step 5 — Lambda #1: Health Check (scheduled)
1. **Lambda → Create function** → Author from scratch → `chainex-health-check` · Runtime **Node.js 20.x**
2. Paste [`lambda/health-check/index.mjs`](lambda/health-check/index.mjs) → **Deploy**
3. Configuration → Environment variables: `APP_URL` = `http://<EC2-IP>`
4. Configuration → General → Timeout **10 s**
5. **Add trigger → EventBridge (CloudWatch Events)** → New rule `every-5-min` → `rate(5 minutes)`
6. **Test** → see `"status":"UP"`. Logs: **Monitor → View CloudWatch logs**.

🗣️ *"Lambda is serverless. AWS runs the code only when it's triggered, and we pay per call. This function monitors our site every 5 minutes."*

## Step 6 — Lambda #2: Backup Notifier (event-driven)
1. Create function `chainex-backup-notifier` · Node.js 20.x
2. Paste [`lambda/backup-notifier/index.mjs`](lambda/backup-notifier/index.mjs) → Deploy
3. **Add trigger → S3** → bucket `chainex-backups-…` · Event: **All object create events** · Prefix `backups/` → acknowledge → Add.

🗣️ *"Every time the server uploads a backup, S3 automatically triggers this Lambda. That's event-driven architecture."*

## Step 7 — Live Demo
1. Open `http://<EC2-IP>/` → log in using the credentials in `login_details.md`.
2. SSH into EC2 → `~/chainiex-supply-chain/deploy/backup-to-s3.sh`
3. Show the new file in S3 → `backups/`
4. Show the CloudWatch logs for **backup-notifier** (📦 New backup) and **health-check** (UP).

## Step 8 — Cleanup
**Terminate EC2 → release the Elastic IP (if used) → delete both Lambdas and the EventBridge rule → empty & delete the S3 bucket → delete the IAM role and security group.**

---

## Cost
| Service | Cost |
|---|---|
| EC2 t3.micro | Free Tier (750 h/month) |
| S3 | Free Tier (5 GB) |
| Lambda + EventBridge | Free Tier (1M requests) |
| CloudWatch Logs | Free Tier (5 GB) |
| Elastic IP | Free while attached to a running instance |

## Appendix — The Same Thing with the AWS CLI
```bash
aws configure                                   # region: us-west-2
aws s3 mb s3://chainex-backups-yourname --region us-west-2
aws ec2 create-security-group --group-name chainex-ec2-sg --description "ChaiNIEx"
aws ec2 authorize-security-group-ingress --group-name chainex-ec2-sg --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 run-instances --image-id <al2023-ami> --instance-type t3.micro \
  --key-name chainex-key --security-groups chainex-ec2-sg \
  --iam-instance-profile Name=chainex-ec2-role --user-data file://deploy/ec2-setup.sh
aws lambda create-function --function-name chainex-health-check --runtime nodejs20.x \
  --handler index.handler --zip-file fileb://health-check.zip --role <lambda-role-arn>
```
🗣️ *"I used the Console so I could show each step visually. The same infrastructure can be scripted with the CLI, or with CloudFormation or Terraform."*

## Likely Viva Questions
- **Why no load balancer?** With a single server, an ALB adds cost (it's not on the Free Tier) without real benefit. To scale later, I'd add an ALB with an Auto Scaling Group.
- **Why not RDS?** To keep it simple and free. RDS would add managed backups and Multi-AZ failover.
- **Lambda vs EC2?** EC2 runs all the time (the stateful app plus the DB). Lambda runs only when triggered, for short tasks.
- **How is it secured?** Private S3 bucket, IAM role instead of access keys, SSH limited to my IP, DB port never exposed, bcrypt password hashes, JWT authentication.
- **Why port 80 → 4000?** Node runs as a normal user on port 4000, and an iptables rule forwards the standard HTTP port to it.
- **What about HTTPS?** Add a domain, and use Nginx with a free Let's Encrypt certificate on the instance.

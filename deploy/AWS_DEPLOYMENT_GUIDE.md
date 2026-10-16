# ChaiNIEx on AWS — Phase-wise Deployment Guide (Oregon, us-west-2)

> **Method:** AWS Console (website). 📸 = take a screenshot for the presentation.
> **Order:** Phase 1 EC2 → Phase 2 S3 (+IAM) → Phase 3 Lambda → Demo → Cleanup. Everything is on the Free Tier.
> **Stuck?** Paste a screenshot along with the **Phase and step number** (e.g. "P1-S7"). That keeps replies short.

## Architecture
```
 Internet ─HTTP:80─► EC2 t3.micro (:80→:4000, Node20+PM2, PostgreSQL16)
                        │ pg_dump (IAM Role)
                        ▼
                     S3 bucket /backups ──ObjectCreated──► Lambda: backup-notifier
 EventBridge (5 min) ─► Lambda: health-check ──GET /api/health──► EC2
                     All Lambda logs ─► CloudWatch
```

## ✅ Values to note down as you go
| Item | Your value |
|---|---|
| EC2 Public IP | ______________ |
| S3 bucket name | chainex-backups-______ |

---

# PHASE 1 — EC2 (App + Database server)

**P1-S1 Region.** Sign in at console.aws.amazon.com. In the top-right region dropdown, choose **US West (Oregon) us-west-2**. 📸

**P1-S2 Open EC2.** Type **EC2** in the top search bar, open it, and click **Launch instance** (orange button).

**P1-S3 Name & OS.**
- Name: `chainex-server`
- Application and OS Images: **Amazon Linux** → **Amazon Linux 2023 AMI** (Free tier eligible)
- Architecture: **64-bit (x86)**

**P1-S4 Instance type.** `t3.micro` (or `t2.micro`, whichever shows "Free tier eligible").

**P1-S5 Key pair.** Click **Create new key pair** → Name `chainex-key` → RSA → **.pem** → Create. The file downloads. Keep it.

**P1-S6 Network settings.** Click **Edit**:
- VPC: default · Subnet: No preference · **Auto-assign public IP: Enable**
- Firewall: **Create security group** → Name `chainex-ec2-sg`
- Rule 1: **ssh**, port 22, Source type **Anywhere** (needed for the browser "EC2 Instance Connect")
- **Add security group rule** → Rule 2: **HTTP**, port 80, Source **Anywhere**
📸

**P1-S7 Storage.** Leave the default (8 GiB gp3).

**P1-S8 User data.** Expand **Advanced details**, scroll to the bottom, and paste the **entire** content of [`deploy/ec2-setup.sh`](ec2-setup.sh) into the **User data** box. Leave `S3_BUCKET` as it is for now; you'll fix it in Phase 2.

**P1-S9 Launch.** Click **Launch instance** → **View all instances**.

**P1-S10 Wait.** Wait until Instance state = **Running** and Status check = **3/3 checks passed**, then wait **another 5 minutes** for the script to finish.

**P1-S11 Get the IP.** Click the instance → copy **Public IPv4 address** → note it in the table above.

**P1-S12 Test.** In your browser, open (use **http**, not https):
- `http://<EC2-IP>/` → customer portal 📸
- `http://<EC2-IP>/admin` → admin portal 📸
- `http://<EC2-IP>/supplier` → supplier portal
- `http://<EC2-IP>/api/health` → `{"success":true...}`

**P1-S13 If it doesn't load:** select the instance → **Connect** → **EC2 Instance Connect** → **Connect** (a terminal opens in the browser). Run:
```bash
sudo tail -50 /var/log/cloud-init-output.log
pm2 status
curl localhost:4000/api/health
```
Screenshot the output and send it to me.

🗣️ *"EC2 is a virtual server. The User Data script installs Node and PostgreSQL, loads the schema and seed data, starts the app with PM2, and forwards port 80 to 4000."*

---

# PHASE 2 — S3 (Backups) + IAM Role

**P2-S1 Create bucket.** Search **S3** → **Create bucket**:
- Bucket type: General purpose · Name: `chainex-backups-<yourname>` (lowercase, must be unique worldwide)
- Region: **us-west-2**
- **Block all public access: ✅ ON** · leave everything else as default → **Create bucket** 📸

**P2-S2 Create IAM role.** Search **IAM** → **Roles** → **Create role**:
- Trusted entity: **AWS service** · Use case: **EC2** → Next
- Search for and tick **AmazonS3FullAccess** → Next
- Role name: `chainex-ec2-role` → **Create role** 📸

**P2-S3 Attach role to EC2.** EC2 → Instances → select `chainex-server` → **Actions → Security → Modify IAM role** → choose `chainex-ec2-role` → **Update IAM role**.

**P2-S4 Set bucket name on server.** Instance → **Connect → EC2 Instance Connect → Connect**, then run (replace the name):
```bash
cd ~/chainiex-supply-chain
sed -i 's/^S3_BUCKET=.*/S3_BUCKET=chainex-backups-yourname/' .env
grep S3_BUCKET .env
```

**P2-S5 Test backup.**
```bash
bash deploy/backup-to-s3.sh
```
You should see: `✅ Backup uploaded: s3://.../backups/chainex-....sql.gz`

**P2-S6 Verify.** S3 → your bucket → `backups/` folder → the file is there. 📸

> A daily automatic backup (02:00 UTC) is already scheduled by the setup script.

🗣️ *"S3 is private object storage for the DB backups. The IAM role lets EC2 upload without storing any access keys on the server."*

---

# PHASE 3 — Lambda (Serverless)

### Lambda A: Health Check (scheduled)
**P3-S1** Search **Lambda** → **Create function** → **Author from scratch**:
- Name `chainex-health-check` · Runtime **Node.js 20.x** · Architecture x86_64 → **Create function**

**P3-S2 Code.** In the **Code** tab, open `index.mjs`, delete everything, paste [`lambda/health-check/index.mjs`](lambda/health-check/index.mjs) → click **Deploy**.

**P3-S3 Env var.** **Configuration → Environment variables → Edit → Add**: Key `APP_URL`, Value `http://<EC2-IP>` (no trailing `/`) → Save.

**P3-S4 Timeout.** **Configuration → General configuration → Edit** → Timeout **10 sec** → Save.

**P3-S5 Test.** **Test** tab → Event name `test` → leave the default JSON → **Test** → the result should show `"status": "UP"`. 📸

**P3-S6 Schedule.** **+ Add trigger** → **EventBridge (CloudWatch Events)** → **Create a new rule** → Name `chainex-every-5-min` → Rule type **Schedule expression** → `rate(5 minutes)` → **Add**. 📸

### Lambda B: Backup Notifier (S3 event)
**P3-S7** **Create function** → Name `chainex-backup-notifier` · **Node.js 20.x** → Create.

**P3-S8 Code.** Paste [`lambda/backup-notifier/index.mjs`](lambda/backup-notifier/index.mjs) → **Deploy**.

**P3-S9 S3 trigger.** **+ Add trigger** → **S3** → Bucket: `chainex-backups-…` → Event types: **All object create events** → Prefix: `backups/` → tick the recursive-invocation acknowledgement → **Add**. 📸

**P3-S10 Test end-to-end.** In the EC2 Instance Connect terminal, run `bash ~/chainiex-supply-chain/deploy/backup-to-s3.sh` again.
Then go to Lambda `chainex-backup-notifier` → **Monitor → View CloudWatch logs** → latest log stream → you should see `📦 New ChaiNIEx backup received`. 📸

**P3-S11 Health logs.** Lambda `chainex-health-check` → **Monitor → View CloudWatch logs** → you should see an `"status":"UP"` entry every 5 minutes. 📸

🗣️ *"Lambda runs code only when it's triggered: one on a schedule (monitoring), one on an S3 event (event-driven). There are no servers to manage, and we pay per call."*

---

# Demo Script (5 min)
1. Open `http://<EC2-IP>/` → log in (credentials are in `login_details.md`) → browse products.
2. EC2 console → show the instance, security group and IAM role.
3. Instance Connect → `bash deploy/backup-to-s3.sh` → S3 → show the new file.
4. CloudWatch → backup-notifier log + health-check UP logs.

# Cleanup (after the presentation)
1. Lambda → delete both functions. EventBridge → Rules → delete `chainex-every-5-min`.
2. S3 → bucket → **Empty** → then **Delete**.
3. EC2 → **Terminate** the instance → Security Groups → delete `chainex-ec2-sg`.
4. IAM → Roles → delete `chainex-ec2-role`.

# Viva Quick Answers
- **Why no load balancer?** There's only one server, and an ALB isn't on the Free Tier. To scale, I'd add an ALB with an Auto Scaling Group.
- **Why not RDS?** To keep it simple and free. RDS would add managed backups and Multi-AZ failover.
- **EC2 vs Lambda?** EC2 runs all the time (the app plus the DB). Lambda is event-driven and short-lived.
- **Security?** Private S3 bucket, IAM role (no keys on the server), DB port 5432 not exposed, bcrypt passwords, JWT authentication.
- **Console vs CLI?** I used the Console so each step is visible. The same setup can be scripted with the AWS CLI, CloudFormation or Terraform.

# AWS Fintech ATM Simulation System

A cloud-based ATM banking simulation built on AWS, demonstrating real-world transaction processing, secure data storage, fraud detection, and role-based access control.

**Author:** Blessing Rakoma | Cloud Engineer / Fintech  
**LinkedIn:** [linkedin.com/in/blessingrakoma](https://www.linkedin.com/in/blessingrakoma)  
**GitHub:** [github.com/BlessingRakoma](https://github.com/BlessingRakoma)

---

## Project Overview

This project simulates core ATM banking operations, deposits, withdrawals, balance tracking, and transaction logging — running entirely on AWS cloud infrastructure.

Built using **Amazon EC2**, **Amazon S3**, and **AWS IAM**, it models how real backend financial systems process transactions, manage persistent data, and enforce security — all within a cloud environment.

---

## Problem Statement

Modern financial systems must handle:
- Accurate and reliable transaction processing
- Secure storage of account data
- Fraud detection and transaction validation
- Clear audit trails for accountability
- Controlled access to system resources

This project addresses each of these requirements using a simplified but functional AWS architecture.

---

## AWS Services Used

| Service | Purpose |
|---|---|
| EC2 (t2.micro) | Hosts and runs the ATM Bash system |
| Amazon S3 | Stores account data and transaction logs |
| AWS IAM | Role-based access control and secure EC2-S3 integration |

---

## System Architecture

```
User (CLI)
    │
    ▼
EC2 Instance (Bash ATM Scripts)
    │
    ├── bank.sh        → Main entry point
    ├── deposit.sh     → Handles deposits + balance update
    ├── withdraw.sh    → Handles withdrawals + fraud checks
    └── statement.sh   → Retrieves transaction history
    │
    ▼
Amazon S3 Bucket
    ├── account.txt    → Stores current balance
    └── logs/          → Timestamped transaction logs
    │
    ▼
IAM Role (EC2 → S3 access, no stored credentials)
```

---

## Security Implementation

A role-based access control (RBAC) model was implemented using AWS IAM:

| Role | Permissions | Purpose |
|---|---|---|
| Admin | Full access | System management |
| Customer | Limited (deposit/withdraw/view) | Account usage |
| Fraud Analyst | Read-only | Monitoring and auditing |

> The EC2 instance accesses S3 via an **IAM role** — no access keys are stored on the instance.

---

## Key Features

### Banking Operations
- Deposit funds with real-time balance update
- Withdraw funds with overdraft prevention
- View current balance
- Persistent storage via S3 (data survives instance restarts)

### Fraud Detection Logic
- **Withdrawal limit enforcement** — flags transactions above a defined threshold
- **Overdraft prevention** — blocks withdrawals that exceed the available balance
- **Suspicious transaction detection** — alerts triggered on unusual activity patterns

### Audit & Logging
- Every transaction is timestamped
- Before and after balances recorded per transaction
- Logs stored in S3 for a persistent audit trail

---

## Build Process

### Prerequisites
- AWS account with Free Tier access
- IAM user with EC2 and S3 permissions
- SSH key pair for EC2 access

### Step 1 — IAM Setup
1. Created IAM users: `admin-user`, `customer-user`, `fraud-analyst.`
2. Created IAM groups with appropriate permission policies
3. Created an IAM role (`ec2-s3-access-role`) with S3 read/write policy
4. Attached the role to the EC2 instance (no access keys used)

### Step 2 — S3 Bucket Setup
```bash
aws s3 mb s3://atm-simulation-bucket
```
- Created `account.txt` to store initial balance
- Created `logs/` prefix for transaction records

### Step 3 — EC2 Instance Setup
```bash
# Launch t2.micro instance (Amazon Linux 2)
# Configure security group: SSH (port 22) from your IP only
# Attach IAM role: ec2-s3-access-role
```

### Step 4 — Deploy ATM Scripts
```bash
# SSH into EC2
ssh -i your-key.pem ec2-user@<your-ec2-public-ip>

# Clone this repo
git clone https://github.com/BlessingRakoma/aws-atm-simulation.git
cd aws-atm-simulation

# Make scripts executable
chmod +x *.sh
```

### Step 5 — Run the ATM System
```bash
./bank.sh
```

---

## Script Overview

| Script | Function |
|---|---|
| `bank.sh` | Main menu — entry point for all operations |
| `deposit.sh` | Accepts deposit amount, updates balance in S3 |
| `withdraw.sh` | Validates withdrawal, checks fraud rules, updates balance |
| `statement.sh` | Retrieves and displays transaction log from S3 |

---

## Screenshots

| Step | Screenshot |
|---|---|
| IAM setup (users, groups, roles) | `screenshots/iam-setup.png` |
| EC2 deployment and SSH access | `screenshots/ec2-ssh.png` |
| S3 bucket and account.txt | `screenshots/s3-bucket.png` |
| ATM deposit operation | `screenshots/deposit.png` |
| ATM withdrawal + fraud alert | `screenshots/fraud-alert.png` |
| Transaction statement log | `screenshots/statement.png` |

---

## Skills Demonstrated

`AWS EC2` `Amazon S3` `AWS IAM` `Bash Scripting` `Linux Administration`  
`RBAC` `Fraud Detection Logic` `Audit Logging` `Transaction Processing` `Cloud Security`

---

## Future Improvements

- [ ] Replace S3 flat-file storage with **DynamoDB** or **RDS** for relational data
- [ ] Add **React frontend** for a browser-based ATM interface
- [ ] Integrate **AWS CloudWatch** for real-time monitoring and alerting
- [ ] Implement a **CI/CD pipeline** using GitHub Actions or AWS CodePipeline
- [ ] Add **multi-user account support**

---

## Key Learnings

- How to deploy and secure an application in AWS end-to-end
- Why IAM roles are preferred over access keys for EC2-to-S3 access
- Managing persistent data using cloud object storage
- Designing systems with validation, logging, and fraud controls
- Building backend logic using Bash scripting on Linux

---

## Author

**Blessing Rakoma**  
Cloud Engineer | Fintech  
[LinkedIn](https://www.linkedin.com/in/blessingrakoma) • [GitHub](https://github.com/BlessingRakoma)

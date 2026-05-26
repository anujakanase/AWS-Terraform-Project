# Setting up Infrastructure on AWS using Terraform

## 📌 Project Overview

This project demonstrates how to provision AWS infrastructure using Terraform.

The architecture includes:

* Custom VPC
* Public Subnets
* EC2 Instances
* Application Load Balancer (ALB)
* Amazon S3
* Security Groups
* Internet Gateway
* Route Tables

Terraform is used as Infrastructure as Code (IaC) to automate the deployment process.

---

# 🏗️ Architecture Diagram

The infrastructure contains:

* VPC with CIDR block
* Two Public Subnets
* Two EC2 Instances
* Application Load Balancer
* S3 Bucket
* Internet Gateway

---

# ⚙️ Technologies Used

| Technology | Purpose                |
| ---------- | ---------------------- |
| Terraform  | Infrastructure as Code |
| AWS EC2    | Virtual Servers        |
| AWS VPC    | Networking             |
| AWS ALB    | Load Balancing         |
| AWS S3     | Storage                |
| Ubuntu     | Operating System       |

---

# 🚀 Terraform Commands

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Preview Infrastructure

```bash
terraform plan
```

## Create Infrastructure

```bash
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```




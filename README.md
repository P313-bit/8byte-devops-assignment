# 8byte DevOps Assignment

Infrastructure-as-Code and containerized application deployment on AWS using Terraform and Docker.

## Overview

This project provisions a highly available AWS application environment using Terraform and runs a lightweight Python application on Docker.

### Technology Stack

* **AWS**

  * VPC
  * Public and Private Subnets
  * Internet Gateway
  * NAT Gateway
  * Application Load Balancer
  * EC2
  * Amazon RDS PostgreSQL
  * Security Groups
* **Terraform**

  * Infrastructure as Code
  * Remote state stored in Amazon S3
* **Docker**

  * Python 3.12 slim image
  * Non-root container execution
* **Python**

  * Simple HTTP application
  * Unit testing with `unittest`
* **Git/GitHub**

  * Version control
  * Feature-based commits

---

## Architecture

```text
                         Internet
                            |
                            v
                  +-------------------+
                  | Application Load  |
                  |     Balancer      |
                  +---------+---------+
                            |
                +-----------+-----------+
                |                       |
                v                       v
        +---------------+       +---------------+
        |   EC2 App 1   |       |   EC2 App 2   |
        |   Port 8080   |       |   Port 8080   |
        +-------+-------+       +-------+-------+
                |                       |
                +-----------+-----------+
                            |
                            v
                   +----------------+
                   | RDS PostgreSQL |
                   |    Private     |
                   +----------------+

       Public Subnets                 Private Subnets
       +-------------+                +-------------+
       |    ALB      |                |   EC2 Apps  |
       | NAT Gateway |                |     RDS     |
       +------+------+                +------+------+
              |                              |
              v                              |
       Internet Gateway                      |
              |                              |
           Internet                    NAT Gateway
```

---

## AWS Infrastructure

The Terraform configuration creates:

* 1 VPC
* 2 public subnets across Availability Zones
* 2 private subnets across Availability Zones
* Internet Gateway
* NAT Gateway with Elastic IP
* Public and private route tables
* Application Load Balancer
* ALB target group
* 2 EC2 application instances
* RDS PostgreSQL instance
* Separate security groups for:

  * ALB
  * Application servers
  * RDS

The application instances listen on **port 8080** and are registered with the ALB target group.

---

## Terraform

Terraform is used to provision and manage the complete AWS infrastructure.

### Directory Structure

```text
terraform/
├── alb.tf
├── data.tf
├── ec2.tf
├── main.tf
├── outputs.tf
├── provider.tf
├── rds.tf
├── security.tf
├── variables.tf
└── .terraform.lock.hcl
```

### File Responsibilities

| File           | Purpose                                    |
| -------------- | ------------------------------------------ |
| `main.tf`      | VPC, subnets and networking                |
| `alb.tf`       | Application Load Balancer and target group |
| `ec2.tf`       | Application EC2 instances                  |
| `rds.tf`       | PostgreSQL database                        |
| `security.tf`  | Security groups                            |
| `data.tf`      | AWS AMI lookup                             |
| `variables.tf` | Terraform variables                        |
| `outputs.tf`   | Infrastructure outputs                     |
| `provider.tf`  | AWS provider and backend configuration     |

---

## Terraform Remote State

Terraform state is stored remotely in an Amazon S3 bucket.

The state bucket is configured with:

* Server-side encryption using AES-256
* Public access blocked
* Remote Terraform state

Terraform state files are excluded from Git using `.gitignore`.

> The actual AWS account ID, bucket name and environment-specific values are intentionally not documented here.

---

## Application

The application is a lightweight Python HTTP server.

```text
GET /
```

returns:

```text
8byte DevOps Assignment - <SERVER_NAME>
```

The application listens on:

```text
0.0.0.0:8080
```

The server name can be configured using the `SERVER_NAME` environment variable.

Example:

```bash
SERVER_NAME=docker
```

returns:

```text
8byte DevOps Assignment - docker
```

---

## Docker

The application is containerized using `python:3.12-slim`.

Security considerations included in the Docker image:

* Minimal Python base image
* `PYTHONDONTWRITEBYTECODE=1`
* `PYTHONUNBUFFERED=1`
* Application runs as the non-root `nobody` user
* Only required application files are copied into the image
* `.dockerignore` excludes unnecessary files

### Build

```bash
docker build -t 8byte-app:local ./app
```

### Run

```bash
docker run -d \
  --name 8byte-app \
  -p 8080:8080 \
  -e SERVER_NAME=docker \
  8byte-app:local
```

### Test

```bash
curl http://localhost:8080
```

Expected response:

```text
8byte DevOps Assignment - docker
```

---

## Testing

Unit tests are implemented using Python's built-in `unittest` framework.

Run:

```bash
python3 -m unittest discover -s app/tests -v
```

Expected result:

```text
Ran 1 test

OK
```

The application was also tested through Docker with multiple HTTP requests.

---

## Deployment

### Prerequisites

Install/configure:

* AWS CLI
* Terraform
* Docker
* Git

Configure AWS credentials:

```bash
aws sts get-caller-identity
```

### Initialize Terraform

```bash
cd terraform
terraform init
```

### Validate

```bash
terraform fmt
terraform validate
```

### Review changes

```bash
terraform plan
```

### Deploy

```bash
terraform apply
```

After deployment:

```bash
terraform output
```

The ALB DNS name can then be used to test the application:

```bash
curl http://<ALB-DNS-NAME>
```

---

## Verification

Infrastructure verification includes:

### Terraform

```bash
terraform validate
terraform plan
```

Expected:

```text
Success! The configuration is valid.

No changes. Your infrastructure matches the configuration.
```

### ALB Target Health

```bash
aws elbv2 describe-target-health \
  --target-group-arn <TARGET-GROUP-ARN>
```

Both application instances should report:

```text
State: healthy
```

### Application

```bash
curl http://<ALB-DNS-NAME>
```

The ALB distributes requests between the application instances.

---

## Security

The project follows several basic security practices:

* Application servers are separated from the public ALB.
* Database access is restricted through a dedicated security group.
* Terraform state is stored remotely in S3.
* S3 public access is blocked.
* S3 server-side encryption is enabled.
* Terraform state and variable files are excluded from Git.
* Database credentials are provided through a sensitive Terraform variable rather than hardcoded in the resource configuration.
* Docker runs the application as a non-root user.

### Sensitive Files

The following files are intentionally excluded from Git:

```text
*.tfstate
*.tfstate.*
*.tfvars
*.tfvars.json
```

Never commit real credentials, passwords, access keys or secrets to the repository.

---

## Repository Structure

```text
8byte-devops-assignment/
│
├── app/
│   ├── app.py
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── requirements.txt
│   └── tests/
│       └── test_app.py
│
├── terraform/
│   ├── alb.tf
│   ├── data.tf
│   ├── ec2.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── rds.tf
│   ├── security.tf
│   ├── variables.tf
│   └── .terraform.lock.hcl
│
├── .gitignore
└── README.md
```

---

## Cleanup

To destroy the AWS infrastructure created by Terraform:

```bash
cd terraform
terraform destroy
```

Review the resources carefully before confirming destruction.

---

## Git History

The project is maintained using Git with separate commits for infrastructure and application changes.

Example:

```text
feat: provision AWS infrastructure with Terraform
feat: containerize application with tests
```

---

## Author

**Pranay Lande**

DevOps Engineer

Technologies demonstrated:

`AWS` · `Terraform` · `Docker` · `Python` · `Linux` · `Git`

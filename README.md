[README (1).md](https://github.com/user-attachments/files/33481412/README.1.md)
# Ironhack DevOps Project 1 — Multi-Stack Voting App

**Project:** Multi-Stack DevOps Infrastructure Automation  
**Stack:** AWS · Terraform · Ansible · Docker · Docker Compose  
**Application source:** [My fork of example-voting-app](https://github.com/AbdulqudusO/example-voting-app)
**Presentation:** [View project presentation slides](https://drive.google.com/file/d/1nggI8qnl1ZGH_8I7qyXuzrXZo_-ot70c/view?usp=sharing)

## Project overview

This project deploys a five-service **Cats vs Dogs** voting application using infrastructure as code and configuration management. I first tested the application locally with Docker Compose, then deployed its components across **three Amazon EC2 instances** using **Terraform** to provision infrastructure and **Ansible** to configure the servers and run Docker containers.

The application consists of:

| Service | Technology | Responsibility |
| --- | --- | --- |
| Vote | Python / Flask | Accepts votes from users |
| Redis | Redis | Temporarily queues submitted votes |
| Worker | .NET | Transfers votes from Redis into PostgreSQL |
| Database | PostgreSQL | Persistently stores the vote data |
| Result | Node.js | Displays the voting results |

**Application data flow:** `Vote → Redis → Worker → PostgreSQL → Result`. The Result service reads the vote data from PostgreSQL.

## AWS architecture

The deployed baseline uses **one Availability Zone (`eu-central-1a`)** in **AWS Frankfurt (`eu-central-1`)**, with a VPC and public/private subnets:

```text
AWS VPC — 10.20.0.0/16
│
├── Public subnet — 10.20.1.0/24
│   └── EC2 A: Vote (:8080) + Result (:8081)
│       └── SSH entry point (bastion access to private instances)
│
└── Private subnet — 10.20.2.0/24
    ├── EC2 B: Redis (:6379) + Worker
    └── EC2 C: PostgreSQL (:5432)
```

Terraform also provisions routing, an Internet Gateway, a NAT Gateway for outbound access from private instances, security groups, and an EC2 key pair. The EC2 application server is publicly reachable; backend and database servers do **not** have public IP addresses. Security groups restrict SSH and application/database connectivity to the required sources.

**Design decision:** I simplified an earlier two-AZ sketch into a single-AZ deployment to focus on correct networking, automation and service connectivity. This is **not** a high-availability or production-grade design; a future version would require genuine cross-AZ redundancy and database failover.

## Automation and repository structure

```text
ironhack-devops-project-1/
├── terraform/             # AWS networking, compute, security and S3 state backend
├── ansible/
│   ├── inventory/         # App, backend and database targets
│   ├── playbooks/         # Docker installation, application deployment, DB password rotation
│   └── ansible.cfg
└── README.md
```

- **Terraform** provisions the AWS resources and uses an **S3 remote state backend with state locking**.
- **Ansible** connects through the application host to manage the private EC2 instances, installs Docker, and deploys the five containers.
- **Docker** packages the application services. My custom Vote, Result and Worker images are published to Docker Hub under `abdulqudus0306`.
- **Docker Compose** was used to verify the same custom application images locally.

The application source is kept in a **separate fork**, preserving its upstream history:

**[Voting application repository →](https://github.com/AbdulqudusO/example-voting-app)**

The application changes include configurable Redis/PostgreSQL host settings through environment variables, safer Worker logging, and a Docker Compose file referencing my custom images.

## Validation performed

- Terraform configuration passed `terraform validate`; a later `terraform plan` reported **no changes**.
- Ansible connected to all three instances and installed/configured Docker successfully.
- All five application services started and were checked with `docker ps` and logs.
- End-to-end voting was verified through the public Vote and Result pages.
- PostgreSQL persistence was tested by restarting the database container and confirming the votes remained available.
- Local Docker Compose testing also verified the custom Vote, Result and Worker images.

## Example verification commands

```bash
# In the Terraform directory
terraform validate
terraform plan

# In the Ansible directory
ansible all -m ping
ansible app -b -a "docker ps"
ansible backend -b -a "docker ps"
ansible db -b -a "docker ps"
ansible backend -b -a "docker logs worker --tail 20"
```

**Note:** Reproducing the deployment requires your own AWS credentials, SSH key and environment-specific Terraform variables/Ansible inventory. Secrets and Terraform state files are deliberately excluded from the repository.

## Limitations and next steps

This is a learning/demo deployment. It currently uses HTTP endpoints and a single Availability Zone. Production enhancements would include HTTPS, secrets management, cross-AZ redundancy with real failover, automated backups, centralized monitoring, and CI/CD.

## References

- [Project presentation slides (Google Drive)](https://drive.google.com/file/d/1nggI8qnl1ZGH_8I7qyXuzrXZo_-ot70c/view?usp=sharing)

- [Infrastructure automation (this repository)](https://github.com/AbdulqudusO/ironhack-devops-project-1)
- [Voting application source and custom Docker Compose configuration](https://github.com/AbdulqudusO/example-voting-app)
- [Original application project](https://github.com/Pokfinner/example-voting-app)

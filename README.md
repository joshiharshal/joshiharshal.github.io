# 🧑‍💻 Portfolio Website Deployment Automation

![Terraform](https://img.shields.io/badge/Terraform-AWS-blue?logo=terraform)
![Ansible](https://img.shields.io/badge/Ansible-Config--Mgmt-red?logo=ansible)
![Docker](https://img.shields.io/badge/Docker-Container-blue?logo=docker)
![EC2](https://img.shields.io/badge/AWS-EC2-orange?logo=amazon-aws)
![SSL](https://img.shields.io/badge/SSL-Let's%20Encrypt-green?logo=letsencrypt)

This project automates the deployment of a **personal portfolio website** on an **AWS EC2 instance** using a single Bash script. It integrates:

- **Terraform** for infrastructure provisioning  
- **Ansible** for installing Docker  
- **Docker** for running the portfolio app  
- **Certbot (Let's Encrypt)** for SSL certificates  
- **Cloudflare** for DNS management  

---

## 📁 Project Structure

```
.
├── Terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── .terraform.lock.hcl
├── ansible/
│   ├── inventory.ini
│   └── docker_deployment.yml
├── harshal/
│   ├── index.html
│   └── packages/
│       ├── css/
│       ├── js/
│       └── images/
├── deploy.sh
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── default.conf
├── my-portfolio.pem
└── README.md
```

---

## ⚙️ Technologies Used

- **Terraform**: Infrastructure provisioning  
- **Ansible**: Configuration management for installing Docker  
- **Docker**: Containerization for running the portfolio application  
- **Certbot**: Automated SSL certificate generation with Let's Encrypt  
- **AWS EC2**: Cloud hosting for the portfolio website  
- **Cloudflare**: DNS management  
- **Bash**: Automation scripting  

---

## 🚀 Features

- Automated provisioning of an AWS EC2 instance using Terraform  
- SSH readiness check before running Ansible playbooks  
- Automated Docker installation and container management  
- SSL certificate generation for HTTPS using Let's Encrypt  
- Clean separation of infrastructure provisioning, configuration, and deployment  
- Persistent SSL certificates using Docker volumes  

---

## 🛠️ Setup Instructions

### 1. Clone the Repository

```sh
git clone https://github.com/joshiharshal/joshiharshal.github.io.git
cd joshiharshal.github.io
```

### 2. Prerequisites

Ensure the following are installed locally:

- Terraform
- Ansible
- Docker
- AWS CLI (configured with your AWS credentials)
- An SSH key (`my-portfolio.pem`) with access to the EC2 instance

### 3. Configure Your Domain

- Set up a subdomain (e.g., `portfolio.joshiharshal.cloud`) in your DNS provider (e.g., Cloudflare).
- Create an A-record pointing to the EC2 instance's public IP address.

### 4. Run the Deployment Script

```sh
chmod +x deploy.sh
./deploy.sh
```

The script performs the following actions:

- Provisions an EC2 instance using Terraform.
- Waits for SSH to become available.
- Uses Ansible to install Docker on the EC2 instance.
- Pulls the portfolio Docker image.
- Generates SSL certificates using Certbot in standalone mode.
- Runs the Docker container on ports 80 (HTTP) and 443 (HTTPS).

---

## 🧹 Clean Up

To tear down the EC2 instance and associated resources:

```sh
cd Terraform
terraform destroy -auto-approve
```

---

## 👤 Author

**Harshal Yogeshwar Joshi**

- Email: harshaljoshi9922@gmail.com
- Website: [joshiharshal.cloud](https://joshiharshal.cloud)
- [LinkedIn](https://www.linkedin.com/in/harshal-joshi003/)
- [GitHub](https://github.com/joshiharshal)

---

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.
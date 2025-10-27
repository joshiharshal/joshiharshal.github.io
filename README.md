# 🧑‍💻 Portfolio Website Deployment Automation

![Terraform](https://img.shields.io/badge/Terraform-AWS-blue?logo=terraform)
![Ansible](https://img.shields.io/badge/Ansible-Config--Mgmt-red?logo=ansible)
![Docker](https://img.shields.io/badge/Docker-Container-blue?logo=docker)
![EC2](https://img.shields.io/badge/AWS-EC2-orange?logo=amazon-aws)
![SSL](https://img.shields.io/badge/SSL-Let's%20Encrypt-green?logo=letsencrypt)

A small automation project to provision an AWS EC2 instance and deploy a personal portfolio website using Terraform, Ansible, Docker, and Certbot. Cloudflare is used for DNS management.

---

## Project structure

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
├── harshal-portfolio.pem
└── README.md
```

---

## Technologies

- Terraform — infrastructure provisioning  
- Ansible — configuration management (install Docker)  
- Docker — containerize the website  
- Certbot (Let's Encrypt) — TLS certificates  
- AWS EC2 — hosting  
- Cloudflare — DNS  
- Bash — orchestration script

---

## Features

- Single-script deployment: provision EC2, wait for SSH, configure instance, run containers  
- Automated Docker installation via Ansible  
- TLS provisioning with Certbot (standalone or nginx mode)  
- Persistent certificate storage using Docker volumes  
- Clear separation: infra (Terraform) → config (Ansible) → deploy (Docker)

---

## Prerequisites

- Local: Terraform, Ansible, Docker, AWS CLI (configured), ssh client  
- An SSH private key with access to the EC2 instance (`harshal-portfolio.pem`)  
- A registered domain and Cloudflare (or other DNS) account

---

## Configure domain

1. Create A record for your domain/subdomain (e.g., `joshiharshal.cloud`) pointing to the EC2 instance public IP.  
2. Ensure Cloudflare proxy is disabled (DNS-only) while obtaining certificates with Certbot standalone; you can enable proxy after successful issuance if desired.

---

## Deployment

1. Clone repository:
```sh
git clone https://github.com/joshiharshal/joshiharshal.github.io.git
cd joshiharshal.github.io
```

2. Make deploy script executable and run:
```sh
chmod +x deploy.sh
./deploy.sh
```

What deploy.sh does (typical flow)
- Runs `terraform init`/`apply` to create EC2 instance  
- Waits for SSH to be available on the new instance  
- Runs Ansible playbook to install Docker and required packages  
- Pulls and starts the website container (maps ports 80/443)  
- Runs Certbot to obtain TLS certificates (standalone) and stores them under `/etc/letsencrypt/live/<domain>/`

If you prefer to provision certificates via nginx, adjust the playbook or use Certbot with `--nginx`.

---

## Creating nginx configuration on the instance

To allow Certbot HTTP-01 challenges and serve the site, create an nginx config (example below). On the instance you can create `/etc/nginx/conf.d/portfolio.conf`:

```nginx
server {
    listen 80;
    server_name joshiharshal.cloud www.joshiharshal.cloud;

    location /.well-known/acme-challenge/ {
        root /usr/share/nginx/html;
    }

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ =404;
    }
}

server {
    listen 443 ssl;
    server_name joshiharshal.cloud www.joshiharshal.cloud;

    ssl_certificate /etc/letsencrypt/live/joshiharshal.cloud/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/joshiharshal.cloud/privkey.pem;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ =404;
    }
}
```

To write the file via SSH:
```sh
sudo tee /etc/nginx/conf.d/portfolio.conf > /dev/null <<'EOF'
# (paste the nginx config here)
EOF
sudo nginx -t && sudo systemctl reload nginx
```

---

## Renewing certificates

If using Certbot standalone:
```sh
sudo certbot renew --pre-hook "systemctl stop nginx" --post-hook "systemctl start nginx"
```
Or configure a cron/systemd timer as preferred.

---

## Tear down / Clean up

To destroy AWS resources created by Terraform:
```sh
cd Terraform
terraform destroy -auto-approve
```

Remember to remove any Cloudflare/DNS records if you no longer need the domain mapping.

---

## Author

Harshal Yogeshwar Joshi  
- Email: harshaljoshi9922@gmail.com  
- Website: https://joshiharshal.cloud  or  https://joshiharshal.github.io/
- GitHub: https://github.com/joshiharshal

---

## License

MIT — see LICENSE file for details.

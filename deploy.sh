#!/bin/bash

set -e

DOMAIN="joshiharshal.cloud"
EMAIL="harshaljoshi9922@gmail.com"
KEY_PATH="/home/harshal/Tasks/joshiharshal.github.io/harshal-portfolio.pem"

echo "🚀 Step 1: Provisioning EC2 with Terraform..."
cd Terraform
terraform init
terraform apply -auto-approve
INSTANCE_IP=$(terraform output -raw instance_public_ip)
cd ..

echo "✅ EC2 instance launched: $INSTANCE_IP"

echo "⏳ Waiting for SSH to be ready..."
while ! ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -i $KEY_PATH ubuntu@$INSTANCE_IP exit 2>/dev/null; do
  sleep 5
done

echo "✅ SSH ready!"

echo "🛠️ Step 2: Running Ansible to install Docker..."
# Terraform already generates inventory
ansible-playbook -i ansible/inventory.ini ansible/docker_deployment.yml

echo "📦 Step 3: Deploying Docker container with SSL..."
ssh -o StrictHostKeyChecking=no -i $KEY_PATH ubuntu@$INSTANCE_IP <<EOF
  set -e

  echo "📦 Pulling Docker image"
  sudo docker pull harshal001/myportfolio:latest

  echo "🛑 Stopping old container (if exists)"
  sudo docker stop myportfolio || true
  sudo docker rm myportfolio || true

  echo "🔐 Running Certbot to generate SSL"
  sudo docker run --rm \
    -v /etc/letsencrypt:/etc/letsencrypt \
    -v /var/lib/letsencrypt:/var/lib/letsencrypt \
    -p 80:80 \
    certbot/certbot certonly --standalone \
      --non-interactive --agree-tos \
      -m harshaljoshi9922@gmail.com \
      -d joshiharshal.cloud

  echo "✅ SSL cert generated:"
  sudo ls -l /etc/letsencrypt/live/joshiharshal.cloud/

  echo "🚀 Starting portfolio container"
  sudo docker run -d --name myportfolio \
    -p 80:80 -p 443:443 \
    -v /etc/letsencrypt:/etc/letsencrypt \
    harshal001/myportfolio:latest
EOF



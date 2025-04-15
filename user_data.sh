#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

cat > /home/ec2-user/docker-compose.yml <<EOF
version: '3'
services:
  web:
    image: nginx
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
EOF

mkdir -p /home/ec2-user/html
echo "<h1>Hello from Terraform!</h1>" > /home/ec2-user/html/index.html

cd /home/ec2-user
docker-compose up -d

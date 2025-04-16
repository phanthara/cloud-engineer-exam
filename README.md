# Cloud Engineer Exam
This project provisions a EC2 instance on AWS using Terraform and deploys Nginx using Docker Compose.

## How to use
1. Set your AWS credentials (aws configure)
2. Replace the key name in terraform apply -var="key_name=your-key"
3. Run terraform init, terraform plan, terraform apply
4. Access the Nginx server via Public IP

## Outputs
- Public IP

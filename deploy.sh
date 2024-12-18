#!/bin/bash

# Define the name of the parameter in SSM (AWS Systems Manager)
PARAMETER_NAME="/flask/sshkey"
EC2_USER="ubuntu"
EC2_HOST="ec2-13-233-153-140.ap-south-1.compute.amazonaws.com"  # Replace with your EC2 instance's public IP
SSH_KEY_PATH="/my-ssh-key.pem"

# Retrieve the SSH key from AWS Systems Manager Parameter Store
echo "Retrieving SSH key from SSM"
aws ssm get-parameter --name "$PARAMETER_NAME" --with-decryption --query "Parameter.Value" --output text > $SSH_KEY_PATH

# Change permissions for the SSH private key
  chmod 400 $SSH_KEY_PATH

# SSH into the EC2 instance and perform deployment tasks
echo "Deploying to EC2 instance..."
ssh -i $SSH_KEY_PATH $EC2_USER@$EC2_HOST << EOF
  # Navigate to the app directory on EC2
 
  cd /home/ubuntu/Deployment || exit
  git pull https://github.com/Manshu-i3/CICDtest.git 
  python3 app.py 
EOF

echo "Deployment completed successfully!"

#!/bin/bash

# Enable error handling: exit if any command fails


# Define the name of the parameter in SSM (AWS Systems Manager)
PARAMETER_NAME="/flask/sshkey"
EC2_USER="ubuntu"
EC2_HOST="ec2-13-233-153-140.ap-south-1.compute.amazonaws.com"  # Replace with your EC2 instance's public IP
SSH_KEY_PATH="/tmp/my-ssh-key.pem"  # Store the SSH private key in /tmp

# Retrieve the SSH key from AWS Systems Manager Parameter Store (with decryption for SecureString)
echo "Retrieving SSH key from SSM..."
aws ssm get-parameter --name "$PARAMETER_NAME" --with-decryption --query "Parameter.Value" --output text > $SSH_KEY_PATH

# Ensure the key has proper permissions
chmod 400 $SSH_KEY_PATH

# Test if the SSH key works by attempting to connect to EC2
echo "Testing SSH connection to EC2 instance..."
ssh -o StrictHostKeyChecking=no -i $SSH_KEY_PATH $EC2_USER@$EC2_HOST "echo 'SSH connection successful'"

# SSH into the EC2 instance and perform deployment tasks
echo "Deploying to EC2 instance..."
ssh -o StrictHostKeyChecking=no -i $SSH_KEY_PATH $EC2_USER@$EC2_HOST << EOF
  # Navigate to the app directory on EC2
  cd /home/ubuntu/Deployment || exit
  
  # Pull the latest code from the GitHub repository
  git pull https://github.com/Manshu-i3/CICDtest.git 
  pkill -f app.py
  nohup python3 app.py 
EOF

echo "Deployment completed successfully!"

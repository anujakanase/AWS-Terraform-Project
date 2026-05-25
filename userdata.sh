#!/bin/bash

# Update packages
apt update -y

# Install Apache
apt install apache2 -y

# Start and enable Apache
systemctl start apache2
systemctl enable apache2

# Get IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)

# Get Instance ID
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
-s http://169.254.169.254/latest/meta-data/instance-id)

# Create HTML page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>AWS EC2 Instance</title>
    <style>
        body {
            background-color: #232F3E;
            color: white;
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 100px;
        }

        h1 {
            font-size: 50px;
        }

        p {
            font-size: 30px;
            color: #FF9900;
        }
    </style>
</head>
<body>

<h1>Terraform Project Server1</h1>

<p>Instance ID: $INSTANCE_ID</p>
<p>Welcome to Devops World</p>
</body>
</html>
EOF
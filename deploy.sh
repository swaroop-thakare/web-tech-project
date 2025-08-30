#!/bin/bash

# EC2 Deployment Script for Web Tech Project
# This script sets up the environment and deploys the application

echo "Starting EC2 deployment..."

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Install Node.js and npm
echo "Installing Node.js..."
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Install Apache and PHP
echo "Installing Apache and PHP..."
sudo yum install -y httpd php php-mysqlnd

# Install MySQL
echo "Installing MySQL..."
sudo yum install -y mysql-server

# Start and enable services
echo "Starting services..."
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Install PM2 for Node.js process management
echo "Installing PM2..."
sudo npm install -g pm2

# Create application directory
echo "Setting up application directory..."
sudo mkdir -p /var/www/web-tech-project
sudo chown -R ec2-user:ec2-user /var/www/web-tech-project

# Copy application files (assuming they're in the current directory)
echo "Copying application files..."
cp -r . /var/www/web-tech-project/

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
cd /var/www/web-tech-project
npm install

# Configure Apache virtual host
echo "Configuring Apache virtual host..."
sudo tee /etc/httpd/conf.d/web-tech-project.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName your-ec2-public-ip
    DocumentRoot /var/www/web-tech-project
    
    <Directory /var/www/web-tech-project>
        AllowOverride All
        Require all granted
    </Directory>
    
    # Proxy Node.js API requests to port 3000
    ProxyPreserveHost On
    ProxyPass /api http://localhost:3000/
    ProxyPassReverse /api http://localhost:3000/
</VirtualHost>
EOF

# Enable Apache modules
echo "Enabling Apache modules..."
sudo a2enmod proxy
sudo a2enmod proxy_http

# Restart Apache
echo "Restarting Apache..."
sudo systemctl restart httpd

# Start Node.js application with PM2
echo "Starting Node.js application..."
cd /var/www/web-tech-project
pm2 start server.js --name "web-tech-project"
pm2 startup
pm2 save

# Configure firewall
echo "Configuring firewall..."
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

echo "Deployment completed!"
echo "Your application should be accessible at: http://your-ec2-public-ip"
echo "Node.js API is running on port 3000"
echo "Apache is serving PHP files from the root directory"

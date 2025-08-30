#!/bin/bash

# New EC2 Instance Setup Script
# This script sets up a fresh EC2 instance with git repository

echo "Setting up new EC2 instance..."

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Install Git first
echo "Installing Git..."
sudo yum install -y git

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

# Clone repository from GitHub
echo "Cloning repository from GitHub..."
cd /var/www/web-tech-project
git clone https://github.com/swaroop-thakare/web-tech-project.git .

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
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

# Set up git configuration for the server
echo "Setting up git configuration..."
git config --global user.name "EC2 Server"
git config --global user.email "server@ec2.local"

echo "New EC2 instance setup completed!"
echo "Your application should be accessible at: http://your-ec2-public-ip"
echo "Node.js API is running on port 3000"
echo "Apache is serving PHP files from the root directory"
echo ""
echo "Next steps:"
echo "1. Configure database: sudo mysql_secure_installation"
echo "2. Create database and user"
echo "3. Set up environment variables: cp env.example .env"
echo "4. Update config.php with database credentials"

# EC2 Deployment Guide for Web Tech Project

## Prerequisites
- AWS Account
- EC2 Instance (Amazon Linux 2 recommended)
- Security Group configured for HTTP (port 80) and HTTPS (port 443)

## Step 1: Launch EC2 Instance

1. Go to AWS Console → EC2 → Launch Instance
2. Choose Amazon Linux 2 AMI
3. Select instance type (t2.micro for free tier, t2.small or larger for production)
4. Configure Security Group:
   - HTTP (80) - 0.0.0.0/0
   - HTTPS (443) - 0.0.0.0/0
   - SSH (22) - Your IP address
5. Launch instance and download key pair

## Step 2: Connect to EC2 Instance

```bash
# Connect via SSH (replace with your key and instance details)
ssh -i your-key.pem ec2-user@your-ec2-public-ip
```

## Step 3: Upload Your Application

### Option A: Using SCP
```bash
# From your local machine
scp -i your-key.pem -r /path/to/your/project ec2-user@your-ec2-public-ip:~/
```

### Option B: Using Git
```bash
# On EC2 instance
git clone your-repository-url
```

## Step 4: Run Deployment Script

```bash
# Make script executable
chmod +x deploy.sh

# Run deployment script
./deploy.sh
```

## Step 5: Configure Database

1. Secure MySQL installation:
```bash
sudo mysql_secure_installation
```

2. Create database and user:
```bash
sudo mysql -u root -p
```

```sql
CREATE DATABASE access_transit;
CREATE USER 'webapp'@'localhost' IDENTIFIED BY 'your-secure-password';
GRANT ALL PRIVILEGES ON access_transit.* TO 'webapp'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

3. Update config.php with new credentials:
```php
$servername = "localhost";
$dbusername = "webapp";
$dbpassword = "your-secure-password";
$dbname = "access_transit";
```

## Step 6: Import Database Schema

If you have a database dump:
```bash
mysql -u webapp -p access_transit < your-database-dump.sql
```

## Step 7: Configure Environment Variables

Create a `.env` file for Node.js:
```bash
# Database configuration
DB_HOST=localhost
DB_USER=webapp
DB_PASSWORD=your-secure-password
DB_NAME=access_transit

# Application settings
NODE_ENV=production
PORT=3000
```

## Step 8: Test Your Application

1. Visit `http://your-ec2-public-ip` for PHP pages
2. Visit `http://your-ec2-public-ip/api/bus-schedules` for Node.js API

## Troubleshooting

### Check Services Status
```bash
# Check Apache status
sudo systemctl status httpd

# Check MySQL status
sudo systemctl status mysqld

# Check PM2 status
pm2 status
```

### View Logs
```bash
# Apache logs
sudo tail -f /var/log/httpd/error_log

# PM2 logs
pm2 logs web-tech-project

# MySQL logs
sudo tail -f /var/log/mysqld.log
```

### Common Issues

1. **Permission Denied**: Ensure files have correct permissions
   ```bash
   sudo chown -R apache:apache /var/www/web-tech-project
   sudo chmod -R 755 /var/www/web-tech-project
   ```

2. **Database Connection**: Verify MySQL is running and credentials are correct

3. **Port Conflicts**: Ensure port 3000 is not used by other services

## Security Considerations

1. **Update Security Group**: Only allow necessary ports
2. **Use HTTPS**: Set up SSL certificate with Let's Encrypt
3. **Regular Updates**: Keep system packages updated
4. **Database Security**: Use strong passwords and limit access
5. **File Permissions**: Set appropriate file permissions

## Monitoring

1. **Set up CloudWatch**: Monitor EC2 metrics
2. **Log Management**: Configure log rotation
3. **Backup Strategy**: Regular database and file backups

## Scaling Considerations

1. **Load Balancer**: Use ALB for multiple instances
2. **Auto Scaling**: Configure auto scaling groups
3. **RDS**: Move database to RDS for better management
4. **CDN**: Use CloudFront for static assets

# Quick EC2 Deployment Commands

## 1. Launch EC2 Instance
- Go to AWS Console → EC2 → Launch Instance
- Choose Amazon Linux 2 AMI
- Select t2.micro (free tier) or t2.small+
- Configure Security Group: HTTP(80), HTTPS(443), SSH(22)
- Launch and download key pair

## 2. Connect to EC2
```bash
ssh -i your-key.pem ec2-user@your-ec2-public-ip
```

## 3. Setup New EC2 Instance (Choose One Option)

### Option A: Clone from Repository (Recommended for new instances)
```bash
# On EC2 instance - download and run setup script
curl -O https://raw.githubusercontent.com/swaroop-thakare/web-tech-project/main/setup-new-ec2.sh
chmod +x setup-new-ec2.sh
./setup-new-ec2.sh
```

### Option B: Manual Setup
```bash
# On EC2 instance
git clone https://github.com/swaroop-thakare/web-tech-project.git
cd web-tech-project
chmod +x deploy.sh
./deploy.sh
```

### Option C: Upload via SCP (Alternative)
```bash
# From your local machine
scp -i your-key.pem -r /Users/swaroopthakare/HPE/web-tech-project ec2-user@your-ec2-public-ip:~/
```

## 5. Setup Database
```bash
# Secure MySQL
sudo mysql_secure_installation

# Create database and user
sudo mysql -u root -p
```

```sql
CREATE DATABASE access_transit;
CREATE USER 'webapp'@'localhost' IDENTIFIED BY 'your-secure-password';
GRANT ALL PRIVILEGES ON access_transit.* TO 'webapp'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 6. Configure Environment
```bash
# Copy example env file
cp env.example .env

# Edit with your database credentials
nano .env
```

## 7. Update PHP Config
```bash
# Edit config.php with new database credentials
nano config.php
```

## 8. Test Application
- Visit: `http://your-ec2-public-ip`
- API: `http://your-ec2-public-ip/api/health`

## 9. Check Services
```bash
# Check all services
sudo systemctl status httpd
sudo systemctl status mysqld
pm2 status
```

## 10. View Logs
```bash
# Apache logs
sudo tail -f /var/log/httpd/error_log

# PM2 logs
pm2 logs web-tech-project

# MySQL logs
sudo tail -f /var/log/mysqld.log
```

## Troubleshooting Commands
```bash
# Restart services
sudo systemctl restart httpd
sudo systemctl restart mysqld
pm2 restart web-tech-project

# Check permissions
sudo chown -R apache:apache /var/www/web-tech-project
sudo chmod -R 755 /var/www/web-tech-project

# Check firewall
sudo firewall-cmd --list-all
```

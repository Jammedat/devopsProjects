# Setup WordPress Website Using LAMP Stack

## Prerequisites
- Ubuntu 22.04 VPS
- SSH root access or a user with sudo privileges
- A Gmail account for SMTP configuration

## 1. System Setup
```bash
sudo apt-get update
sudo apt-get upgrade
```

## 2. Install Apache
```bash
sudo apt-get install apache2
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2
```

Verify at: `http://your_server_ip_address`

## 3. Install MySQL
```bash
sudo apt install mysql-server
sudo mysql_secure_installation
sudo systemctl start mysql
sudo systemctl enable mysql
```

Access MySQL:

```bash
sudo mysql -u root -p
```

## 4. Install PHP
```bash
sudo apt install php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
```

## 5. Install WordPress
```bash
cd /var/www/html
sudo wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo chown -R www-data:www-data /var/www/html/wordpress
```

Create Database:
```bash
sudo mysql -u root -p

CREATE DATABASE wp_wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'strongpassword';
GRANT ALL PRIVILEGES ON wp_wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

Configure WordPress:
```bash
cd /var/www/html/wordpress
sudo mv wp-config-sample.php wp-config.php
sudo vi wp-config.php
```

Update database credentials.

Restart your Apache and MySQL server with:

```bash
systemctl restart apache2
systemctl restart mysql
```
With this being done, you can now access your WordPress page and finish the installation by following the on-screen instructions in your browser at `http://your_server_ip_address/wordpress`

Choose your language and click “Continue”.
Enter your preferred information at the main installation screen, such as site title, username, password and email, and click on “Install WordPress”.

After a successful login, you will be greeted by the WordPress dashboard page. 

## 6. Configure Gmail SMTP
In WordPress:
Install "WP Mail SMTP" plugin
Go to: WP Admin → Settings → WP Mail SMTP
Select "Other SMTP"

In Google Cloud Console:
Create project at Google Cloud Console
Enable "Gmail API" (Library → Search "Gmail API" → Enable)

Configure OAuth consent screen:
User Type: External
Publishing Status: In Prouction

Create credentials:
Application type: Web application
Add authorized redirect URI from WP Mail SMTP settings
Copy Client ID and Secret to WP Mail SMTP settings

Test Configuration:
In WP Mail SMTP, go to "Test Email" tab
Send test email to verify setup
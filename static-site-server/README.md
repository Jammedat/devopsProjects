## Static Site Server

### Step 1 - Register and setup remote server on AWS or Azure
Note: This is aligned with Azure
1. Create a VM.
2. Allow port 80 in INbound port rules.

### Step 2 - Install and configure Nginx
1. Connect to your azure VM

2. Update your system:

```
sudo apt update -y
```

3. Install, run and enable Nginx:

```
sudo apt install nginx  
sudo systemctl start nginx  
sudo systemctl enable nginx
```

4. Create:

```
sudo mkdir -p /var/www/html
```

5. Set the correct permissions and ownership

```
sudo chown -R azureuser:azureuser /var/www/html  
sudo chmod -R 755 /var/www/html
```

7. Configure Nginx to serve your static site:

```
sudo vim /etc/nginx/nginx.conf
```

In the ```server``` block, update the ```root``` directives:

```
root /var/www/html;
```

8. Save and exit, then restart Nginx:

```
sudo systemctl restart nginx
```

### Step 3 - Prepare Your Static Site
1. On your local machine, create a directory for your static site
2. Create your HTML, CSS, and add image files to this directory.

### Step 4 - Use rsync to Update the Remote Server (Deployment Script)
1. On your local machine, create a file named deploy.sh and write the script.
2. Make the script executable:

```
chmod +x deploy.sh
```

3. Run the script.

### Step 5 - Access your site through the public ip address of your VM.

##

Note: If you are windows user, you need to use ```WSL``` for the script to run as ```rsync``` cannot be executed in windows. Also while using ```wsl``` its better to follow the following approach to not encounter the issues related to the permissions:

1. Copy the private key file from your previous locations like ```/mnt/c/Users/username/Downloads/``` to your WSL home directory:

```
mkdir -p ~/.ssh  
cp /mnt/c/Users/username/Downloads/static_key.pem ~/.ssh/
```

2. Set the correct permissions for the key file in the Linux filesystem:

```
chmod 400 ~/.ssh/<private-key-file>
```





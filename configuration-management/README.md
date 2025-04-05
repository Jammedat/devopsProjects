# Ansible Playbook for Server Setup and Static Website Deployment

This playbook automates the setup of a server with Nginx to host a static website, along with essential security and utility configurations.

## Overview

The playbook consists of four roles that perform the following tasks:

1. **Base Role**: Basic server configuration
2. **Nginx Role**: Web server installation and configuration
3. **App Role**: Static website deployment
4. **SSH Role**: SSH key configuration for password-less login

## Prerequisites

- Ansible installed on your control machine
- SSH access to the target server(s)
- Sudo privileges on the target server(s)
- Static website files packaged in `website.tar.gz`

## Roles

### Base Role
Performs fundamental server configuration:
- Updates all system packages
- Installs essential utilities (vim, git, curl)
- Installs and configures Fail2ban for security

### Nginx Role
Installs and configures Nginx web server:
- Installs Nginx package
- Starts and enables Nginx service
- Deploys custom Nginx configuration (`nginx.conf.j2` template required)

### App Role
Deploys the static website:
- Uploads `website.tar.gz` to the server
- Extracts contents to `/var/www/html`

Package your static HTML website into compressed tarball as:
- Navigate to your website directory:
- Create the tarball:
```bash
tar -czvf <name_of_your_web_dir>.tar.gz *
```
### SSH Role
Configures SSH access:
- Adds your public key to `authorized_keys`
- Enables password-less SSH login

Note:
In case of using WSL:
- Create a directory as:
```bash
mkdir -p ~/.ssh
```
- Give the necessary permission to the downloaded key-pem file of your vm:
```bash
chmod 600 /mnt/c/Users/<username>/Ddownloads/<pem_file>
```
- Copy this pem file to the directory ~/.ssh
```bash
cp /mnt/c/Users/<username>/Downloads/<pem_file> ~/.ssh/
```
- Again give the necessary permission:
```bash
chmod 400 ~/.ssh/<pem_file>
```
- Now generate a public key from the private key file as:\
ssh-keygen -y -f ~/.ssh/ansi_key.pem > ~/.ssh/ansi_key.pub

## Usage

### Running the Complete Playbook
```bash
ansible-playbook -i inventory.ini setup.yml
```

### Running Specific Roles
Use the `--tags` option to run only selected roles:

```bash
# Run only the base role
ansible-playbook -i inventory.ini setup.yml --tags "base"

# Run only the app role
ansible-playbook -i inventory.ini setup.yml --tags "app"
```

## Configuration

1. **Inventory**: Edit `inventory.ini` to specify your target servers
2. **Nginx Config**: Provide your custom `nginx.conf.j2` template
3. **Website Package**: Ensure `website.tar.gz` exists at the specified path

## Files Structure

```
├── website.tar.gz
├── inventory.ini
├── setup.yml
├── roles/
│   ├── base/
│   │   ├── tasks/
│   │   │   └── main.yml
│   ├── nginx/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── templates/
│   │   │   └── nginx.conf.j2
│   ├── app/
│   │   ├── tasks/
│   │   │   └── main.yml
│   ├── ssh/
│   │   ├── tasks/
│   │   │   └── main.yml
```


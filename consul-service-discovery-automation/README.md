# Automation (IaC) for the Consul Service Discovery Project using Terraform and Ansible

## Provision the infrastructure in Azure using Terraform
cd into terraform directory
1. Initialize Terraform 
```bash
terraform init
```

2. Dry run Terraform
```bash
terraform plan
```

3. Provision by applying the configurations
```bash
terraform apply
```

## Configure using Ansible
cd into ansible directory
1. Configure Consul server
```bash
ansible-playbook -i inventory.ini consul.yaml
```

2. Configure Backends
Get the consul server private ip address and save it in the PRIVATE_IP variable.
```bash
ansible-playbook -i  getPrivateIP.yaml
```

Execute the playbook
```bash
ansible-playbook -i inventory.ini -e "consul_server_address=$PRIVATE_IP" backends.yaml
```

3. Configure Loaddbalancer
```bash
ansible-playbook -i inventory.ini -e "consul_server_address=$PRIVATE_IP:8500" loadbalancer.yaml
```

Note: The manual setup of this project is provided [here](https://github.com/Jammedat/devopsProjects/tree/main/consul-service-discovery).
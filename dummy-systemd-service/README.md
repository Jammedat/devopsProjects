## Dummy Systmemd Service

The goal of this project is to get familiar with systemd; creating and enabling a service, checking the status, keeping an eye on the logs, starting and stopping the service, etc.

### Requirements

1. Create a script called ```dummy.sh``` that keeps running forever and writes a message to the log file every 10 seconds simulating an application running in the background.

```
sudo vi /usr/local/bin/dummy.sh
```

2. Make the script executable:

```
sudo chmod +x /usr/local/bin/dummy.sh
```

3. Create a systemd service dummy.service that should start the app automatically on boot and keep it running in the background. If the service fails for any reason, it should automatically restart.

```
sudo vi /etc/systemd/system/dummy.service
```

4. Enable and start the service

Reload the systemd to recognize new service:

```
sudo systemctl daemon-reload
```

Enable the service to start on boot:

```
sudo systemctl enable dummy
```

Start the service;

```
sudo systemctl start dummy
```

5. CHeck the service status and logs

Check if service is running:

```
sudo systemctl status dummy
```

Check the realtime logs:

```
sudo journalctl -u dummy -f
```

Open the log file to verify:

```
sudo tail -f /var/log/dummy-service.log

### Interacting with the service

```
sudo systemctl start dummy  
sudo systemctl stop dummy  
sudo systemctl enable dummy  
sudo systemctl disable dummy  
sudo systemctl status dummy
```


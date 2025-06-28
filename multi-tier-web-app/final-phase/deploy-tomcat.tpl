#!/bin/bash

# Update system packages
sudo apt update
sudo apt upgrade -y

# Install Java 17
sudo apt install openjdk-17-jdk wget unzip git -y

# Set JAVA_HOME globally
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" | sudo tee -a /etc/profile.d/java.sh
source /etc/profile.d/java.sh

# Download and extract Tomcat 10
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.42/bin/apache-tomcat-10.1.42.tar.gz
sudo tar -xvzf apache-tomcat-10.1.42.tar.gz
sudo mv apache-tomcat-10.1.42 tomcat10
sudo rm apache-tomcat-10.1.42.tar.gz
sudo chown -R azureuser:azureuser /opt/tomcat10

# Give execute permission to scripts
sudo chmod +x /opt/tomcat10/bin/*.sh

# Download WAR file from Azure Blob
wget "<blob SAS url>" -O /tmp/vprofile-v2.war

# Deploy WAR to Tomcat 10
sudo chown -R azureuser:azureuser /opt/tomcat10
cp /tmp/vprofile-v2.war /opt/tomcat10/webapps/ROOT.war

# Start Tomcat 10
/opt/tomcat10/bin/startup.sh

# Wait until WAR is expanded and app is accessible
for i in {1..15}; do
    sleep 5
    if [ -d /opt/tomcat10/webapps/ROOT/WEB-INF ]; then
        status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/welcome)
        if [[ "$status" == "200" ]]; then
            echo "App deployed and reachable!"
            break
        else
            echo "App deployed but not reachable yet (HTTP $status)"
        fi
    else
        echo "Waiting for WAR to expand..."
    fi
done
# Jenkins Pipeline for Java based application using Maven, SonarQube, Argo CD, Helm and Kubernetes

![Screenshot 2023-03-28 at 9 38 09 PM](https://user-images.githubusercontent.com/43399466/228301952-abc02ca2-9942-4a67-8293-f76647b6f9d8.png)


Here are the step-by-step details to set up an end-to-end Jenkins pipeline for a Java application using SonarQube, Argo CD, Helm, and Kubernetes:

Prerequisites:

   -  Java application code hosted on a Git repository
   -   Jenkins server
   -  Kubernetes cluster
   -  Helm package manager
   -  Argo CD

Steps:

    1. Install Jenkins.

      Pre-Requisites:
       - Java (JDK)

        Run the below commands to install Java and Jenkins

      Install Java

      sudo apt update
      sudo apt install openjdk-17-jre

      Verify Java is Installed
      java -version

      Now, you can proceed with installing Jenkins

      curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
      sudo apt-get update
      sudo apt-get install jenkins


      **Note: ** By default, Jenkins will not be accessible to  the external world due to the inbound traffic restriction  by Azure. Open port 8080   in the inbound traffic rules  
      as show below.

      - Go to VM you created
      - In the side bar -> Click on Networking -> Networking Settings
      - Click on Create port rule -> inbound rule
      - Add inbound traffic rules 8080 in destination port

      Login to Jenkins using the below URL:
      http://<vm-public-ip-address>:8080

      After you login to Jenkins, 
            - Run the command to copy the Jenkins Admin Password - `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
            - Enter the Administrator password

      Click on Install suggested plugins

      Wait for the Jenkins to Install suggested plugins

      Create First Admin User or Skip the step [If you want to  use this Jenkins instance for future use-cases as well,  better to create admin user]

      Jenkins Installation is Successful. You can now starting using the Jenkins 

      Install the Docker Pipeline plugin in Jenkins:

         - Log in to Jenkins.
         - Go to Manage Jenkins > Manage Plugins.
         - In the Available tab, search for "Docker Pipeline".
         - Select the plugin and click the Install button.
         - Restart Jenkins after the plugin is installed.

      Wait for the Jenkins to be restarted.


      Docker Slave Configuration

      Run the below command to Install Docker
      sudo apt update
      sudo apt install docker.io


      Grant Jenkins user and Ubuntu user permission to docker deamon.
      sudo su - 
      usermod -aG docker jenkins
      usermod -aG docker ubuntu


      Once you are done with the above steps, it is better to restart Jenkins.
      http://<vm-public-ip>:8080/restart


      The docker agent configuration is now successful.


    2. Install the necessary Jenkins plugins:
       2.1 Git plugin
       2.2 Maven Integration plugin
       2.3 Pipeline plugin
       2.4 Kubernetes Continuous Deploy plugin

    3. Create a new Jenkins pipeline:
       2.1 In Jenkins, create a new pipeline job and configure  it with the Git repository URL for the Java application.
       2.2 Add a Jenkinsfile to the Git repository to define the pipeline stages.

    4. Define the pipeline stages:
        Stage 1: Checkout the source code from Git.
        Stage 2: Build the Java application using Maven.
        Stage 3: Run unit tests using JUnit and Mockito.
        Stage 4: Run SonarQube analysis to check the code quality.
        Stage 5: Package the application into a JAR file.
        Stage 6: Deploy the application to a test environment using Helm.
        Stage 7: Run user acceptance tests on the deployed application.
        Stage 8: Promote the application to a production environment using Argo CD.

    5. Configure a Sonar Server locally
         sudo su -
         apt install unzip
         adduser sonarqube
         sudo su -sonarqube
         wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
         unzip *
         chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
         chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424
         cd sonarqube-9.4.0.54424/bin/linux-x86-64/
         ./sonar.sh start

         Hurray !! Now you can access the `SonarQube Server` on `http://<ip-address>:9000`
    
    6. Add the necessary credentials in Jenkins to authenticate with:
       6.1 Sonarqube
          Access the sonarqube and generate tokens by going to  the security and use tokens as a secret text in  
          global credentials in Jenkins by going to the manage  credentials.
       6.2 Docker Hub
          In global credentials add docker's credentials -  choose Username with password and insert username  
          and password as your dockerhub's and insert id as  'docker-cred'.
       6.3 GitHub
          Go to the settings of your Github account and  
          generate a classic tokens by going to Developer  settings > Personal access tokens > Tokens (classic) 
           > Generate new token and add that in global  credentials as secret text by inserting ID as  'github' and secret as the tokens. 

    7. Configure Jenkins pipeline stages:
        Stage 1: Use the Git plugin to check out the source code from the Git repository.
        Stage 2: Use the Maven Integration plugin to build the Java application.
        Stage 3: Use the JUnit and Mockito plugins to run unit tests.
        Stage 4: Use the SonarQube plugin to analyze the code quality of the Java application.
        Stage 5: Use the Maven Integration plugin to package the application into a JAR file.
        Stage 6: Use the Kubernetes Continuous Deploy plugin to  deploy the application to a test environment using Helm.
        Stage 7: Use a testing framework like Selenium to run  user acceptance tests on the deployed application.
        Stage 8: Use Argo CD to promote the application to a production environment.

    8. Set up Argo CD:
        Install Argo CD on the Kubernetes cluster.
        Set up a Git repository for Argo CD to track the  
        changes in the Helm charts and Kubernetes manifests. 
        Create a Helm chart for the Java application that  includes the Kubernetes manifests and Helm values. 
        Add the Helm chart to the Git repository that Argo CD is tracking.

    9. Run the Jenkins pipeline:
       9.1 Trigger the Jenkins pipeline to start the CI/CD process for the Java application.
       9.2 Monitor the pipeline stages and fix any issues that arise.
   
    11. Install and configure Argo-CD on kubernetes locally
      First configure minikube as: minikube start --memory=4098 --driver=docker
       11.1 Install OLM:
       `curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.32.0/install.sh | bash -s v0.32.0`
       11.2 Install the operator:
       `kubectl create -f https://operatorhub.io/install/argocd-operator.yaml`
       11.3 Create argocd-basic.yml:
       ```
          apiVersion: argoproj.io/v1alpha1
          kind: ArgoCD
          metadata:
            name: example-argocd
            labels:
              example: basic
          spec:
            server:
              service:
                type: NodePort
                ```
       11.4 Check the services as: kubectl get svc
       11.5 Edit the type in example-argocd-server from ClusterIp to NodePort
       11.6 Access the url as: minikube service example-argocd-server and minikube service list
       Verify the pods are running as: kubectl get pods
       11.7 Sign in with username as admin and get the password as:
       kubectl get secret
       kubectl edit secret example-argocd-cluster

       Copy the secret and convert it as:
       echo "secret" | base64 -d
       11.8 Click on create application and provide necessary  information of the github repo and you are good to go.
       11.9 Deploy as: kubectl get deploy
       11.10 Verify pods are running as: kubectl get pods
       11.11 Try to edit and change the code on the files and see if ArgoCD is working or not.



This end-to-end Jenkins pipeline will automate the entire CI/CD  process for a Java application, from code checkout to production  
deployment, using popular tools like SonarQube, Argo CD, Helm,  and Kubernetes.

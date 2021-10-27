# jenkins_terraform_v1.3
jenkins_terraform_v1.3 


# Prerequisite
1. You need atleast 2 aws accounts to setup Jenkins Master/Slave cluster
2. Install Terraform version 1.0 or above in your local machine
3. Install Docker CLI in your local machine
4. Install AWS CLI in your local machine
5. Configure 2 AWS profiles in your local machine, with proper names. (For eg : jenkins-controller & jenkins-agent1)
6. Create Terraform state S3 bucket (private bucket) via aws console


VERFICATION
1. Go to AWS console, and open Systems Manager > Parameter Store > open "jenkins-pwd" and note down the value. This is your jenkins UI password.
2. Go to AWS console, and open EC2 > LoadBalancers > Note the "DNS Name of "serverless-jenkins-crtl-alb" LB. This is the URL of your jenkins.
3. Try to access the Jenkins URL in your browser and login with user "ecsuser" and use the above password (step #1).

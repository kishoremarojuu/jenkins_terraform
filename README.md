# jenkins_terraform_v1.3

# Prerequisite
1. You need atleast 2 aws accounts to setup Jenkins Master/Slave cluster
2. Install Terraform version 1.0 or above in your local machine
3. Install Docker CLI in your local machine
4. Install AWS CLI in your local machine
5. Configure 2 AWS profiles in your local machine, with proper names. (For eg : jenkins-controller & jenkins-agent1)
6. Create Terraform state S3 bucket (private bucket) via aws console

### notes:
1. run terraform agent_ecs first, update terraform.tf and jenkins-agents.tf with correct values
2. update the subnets, sg values in the jenkins controller. also rename controller to .disabled
3. run terrafrom in jenkins controller folder, this will spin up networking first such as VPC, subnets, internet gateway, wait for 3 mins
4. rename jenkins controller.disabled to regular and run terraform init, apply in jekins controller folder
5. Access jenkins UI, run local jobs, ec2 agent job

running fargate now
7. update terraform.tf, update bucket key(mandatory) and jenkins-agent.tf  with respective providers
8. update  jenkins_controller_account_id to point to masterController accont id in jenkins-agent.tf
9. run terraform apply in fargate folder
10. update the subnet, sg values in the jenkins console as well, this is manuually doing //todo automation later
11. also update the IAM role under mainController, not sure why this is happening //todo
    "Resource": [
    "arn:aws:iam::602710607084:role/jenkins-deploy-role",
    "arn:aws:iam::461415053208:role/jenkins-deploy-role"
    "arn:aws:iam::480455260188:role/jenkins-deploy-role"
    ]
12. Testing fargate remote job now.


## VERFICATION
1. Go to AWS console, and open Systems Manager > Parameter Store > open "jenkins-pwd" and note down the value. This is your jenkins UI password.
2. Go to AWS console, and open EC2 > LoadBalancers > Note the "DNS Name of "serverless-jenkins-crtl-alb" LB. This is the URL of your jenkins.
3. Try to access the Jenkins URL in your browser and login with user "ecsuser" and use the above password (step #1).


### some terraform commands
terraform state show "module.jenkins_agent.module.fargate[0].aws_iam_role.ecs_execution_role"
terraform state ls
terraform apply -target="module.jenkins_agent_vpc.aws_vpc.this[0]"
terraform apply -target='module.jenkins_agent.module.ecs[0].aws_iam_instance_profile.ecs'


test acocunts
master account: 871244369079 , <<871244369079.cutomimage>>

ec2 agent: 461415053208, IAM role to pull the image from masterAccount
fargate agent: 602710607084



### Issues:
1. add 602710607084 IAM role in master account IAM role to get the clustername in drop down
   also update the subnets, security groups from the terrafrom output to jenkins, manager jenkins, configue clouds, fargate-remote account

  in the remote account, under task-permission: please point it to controller root account

9. automate the jenkins-controller.tf to read multi agents instead of hardcoding them

3. jenkins-agent.tf line no: 53, manually adding the controller, automate this asap.



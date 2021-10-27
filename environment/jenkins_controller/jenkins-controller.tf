data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  name_prefix = "serverless-jenkins"

  tags = {
    team     = "devops"
    solution = "jenkins"
    project  = "poc"
  }
}

resource "aws_kms_key" "efs_kms_key" {
  description = "KMS key used to encrypt Jenkins EFS volume"
}

resource "random_password" "jenkins_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_ssm_parameter" "jenkins_password" {
  lifecycle {
    ignore_changes = [value]
  }
  type  = "SecureString"
  name  = "jenkins-pwd"
  value = random_password.jenkins_password.result
}

module "serverless_jenkins" {
  #count = 0
  source          = "../../modules/jenkins_controller"
  name_prefix     = local.name_prefix
  tags            = local.tags
  vpc_id          = module.vpc.vpc_id
  efs_kms_key_arn = aws_kms_key.efs_kms_key.arn

  # Use private subnet IDs
  efs_subnet_ids                = module.vpc.private_subnets
  jenkins_controller_subnet_ids = module.vpc.private_subnets

  # Use Public subnet IDs
  alb_subnet_ids = module.vpc.public_subnets

  // CHANGE Following Values
  remote_agent_account_id           = ""                                                #CHANGEME
  remote_agent_subnets              = "subnet-0286e0a4977e9ea24, subnet-0fd07b596721ee" #CHANGEME
  remote_agent_security_groups      = "sg-04f932ece047b31e0"                            #CHANGEME
  remote_agent_ecs_cluster_name     = ""                                                #CHANGEME
  remote_agent_fargate_cluster_name = ""                                                #CHANGEME  
}


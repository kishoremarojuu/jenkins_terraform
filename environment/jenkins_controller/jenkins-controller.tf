data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  name_prefix = "serverless-jenkins"

  tags = {
    team     = "ruo"
    solution = "jenkins"
    project  = "ruo-jenkins"
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
  remote_agent_subnets              = "subnet-08a7c7a57722fa82f, subnet-0b24413f38002a2a7" #CHANGEME
  remote_agent_security_groups      = "sg-06df7e240cac01cc4"                            #CHANGEME
  remote_agent_ecs_cluster_name     = ""                                                #CHANGEME
  remote_agent_fargate_cluster_name = ""                                                #CHANGEME  
}

data "aws_route53_zone" "archer_net_zone" {
  provider = aws.route53mainaccount
  name     = "archerdx.net."
}

resource "aws_route53_record" "jenkins_dns" {
  provider = aws.route53mainaccount
  zone_id  = data.aws_route53_zone.archer_net_zone.zone_id
  name     = "cicd.${data.aws_route53_zone.archer_net_zone.name}"
  type     = "CNAME"
  ttl      = "300"
  records  = [module.serverless_jenkins.lb_dns_name]
  lifecycle {
    create_before_destroy = true
  }
}
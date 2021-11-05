locals {
  tags = {
    team     = "devops"
    solution = "jenkins"
    project  = "poc"
  }
}

resource "tls_private_key" "ecs" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ecs" {
  key_name   = "ecs-key-${var.environment}"
  public_key = tls_private_key.ecs.public_key_openssh
}

// Jenkins Agent VPC
module "jenkins_agent_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-agent-poc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  tags = local.tags
}

// Jenkins ECS/Fargate agent
module "jenkins_agent" {
  source = "../../modules/jenkins_agent"

  create_ecs_agent     = true
  create_fargate_agent = false #CHANGEME

  name_prefix        = var.name_prefix
  private_subnet_ids = module.jenkins_agent_vpc.private_subnets
  availability_zones = var.availability_zones
  instance_type      = var.instance_type
  max_size           = var.max_size
  min_size           = var.min_size
  desired_capacity   = var.desired_capacity
  vpc_id             = module.jenkins_agent_vpc.vpc_id
  key_name           = aws_key_pair.ecs.key_name
  cloudwatch_prefix  = "jenkinsAgent"
  ecs_aws_ami        = var.aws_ecs_ami
  tags               = local.tags

  // CHANGE Following Values
  jenkins_controller_account_id = "317443947632" #CHANGEME
}
// Outputs
output "jenkins_agent_private_subnets" {
  value = module.jenkins_agent_vpc.private_subnets
}
output "jenkins_agent_sg_id" {
  value = module.jenkins_agent.jenkins_agent_sg_id
}

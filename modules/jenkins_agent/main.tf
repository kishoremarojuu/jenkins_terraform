data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# data "aws_vpc" "selected" {
#   id = var.vpc_id
# }

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

resource "aws_security_group" "jenkins_agent" {

  name        = "${var.name_prefix}-sg"
  description = "${var.name_prefix} security group"
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}


module "ecs" {
  source = "../ecs"
  count  = (var.create_ecs_agent == true) ? 1 : 0

  name_prefix        = var.name_prefix
  cluster_name       = var.cluster_name
  instance_group     = var.instance_group
  private_subnet_ids = var.private_subnet_ids
  aws_ami            = var.ecs_aws_ami
  instance_type      = var.instance_type
  max_size           = var.max_size
  min_size           = var.min_size
  desired_capacity   = var.desired_capacity
  vpc_id             = var.vpc_id
  key_name           = var.key_name
  custom_userdata    = var.custom_userdata
  cloudwatch_prefix  = var.cloudwatch_prefix
  tags               = var.tags
}


module "fargate" {
  source = "../fargate"
  count  = (var.create_fargate_agent == true) ? 1 : 0

  name_prefix = var.name_prefix
  tags        = var.tags
}
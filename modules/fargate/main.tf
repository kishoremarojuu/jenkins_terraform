data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# data "aws_vpc" "selected" {
#   id = var.vpc_id
# }

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

# resource "aws_security_group" "jenkins_agent" {

#   name        = "${var.name_prefix}-sg"
#   description = "${var.name_prefix} security group"
#   vpc_id      = var.vpc_id

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = var.tags
# }
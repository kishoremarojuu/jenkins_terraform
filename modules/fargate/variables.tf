
variable "name_prefix" {
  type    = string
  default = "serverless-jenkins"
}

# variable "vpc_id" {
#   type = string
# }

variable "tags" {}

variable "create_ecs_task_def_for_agents" {
  default = false
}
variable "jenkins_controller_account_id" {}

variable "ecr_account_id" {}
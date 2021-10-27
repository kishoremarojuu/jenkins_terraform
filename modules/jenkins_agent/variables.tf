// Common
variable "create_ecs_agent" {
  default = false
}

variable "create_fargate_agent" {
  default = false
}

variable "name_prefix" {
  type    = string
  default = "jenkins-agent"
}

variable "vpc_id" {
  type = string
}

variable "tags" {}

variable "jenkins_controller_account_id" {}

// ECS

variable "cluster_name" {
  default     = "jenkins-agent"
  description = "The name of the ECS cluster"
}

variable "instance_group" {
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "private_subnet_ids" {
  type        = list(any)
  description = "List of private subnet IDs"
}

variable "availability_zones" {
  type        = list(any)
  description = "List of availability zones you want. Example: eu-west-1a and eu-west-1b"
}

variable "max_size" {
  description = "Maximum size of the nodes in the cluster"
}

variable "min_size" {
  description = "Minimum size of the nodes in the cluster"
}

variable "desired_capacity" {
  description = "The desired capacity of the cluster"
}

variable "key_name" {
  description = "SSH key name to be used"
}

variable "instance_type" {
  description = "AWS instance type to use"
}

variable "ecs_aws_ami" {
  description = "The AWS ami id to use for ECS"
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

// FARGATE
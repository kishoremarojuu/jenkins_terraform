variable "environment" {
  description = "A name to describe the environment we're creating."
}

variable "name_prefix" {
  description = "A name to prefix with resources we're creating."
}
variable "aws_ecs_ami" {
  description = "The AMI to seed ECS instances with."
}
variable "vpc_cidr" {
  description = "The IP range to attribute to the virtual network."
}
variable "public_subnet_cidrs" {
  description = "The IP ranges to use for the public subnets in your VPC."
  type        = list(any)
}
variable "private_subnet_cidrs" {
  description = "The IP ranges to use for the private subnets in your VPC."
  type        = list(any)
}
variable "availability_zones" {
  description = "The AWS availability zones to create subnets in."
  type        = list(any)
}
variable "max_size" {
  description = "Maximum number of instances in the ECS cluster."
}
variable "min_size" {
  description = "Minimum number of instances in the ECS cluster."
}
variable "desired_capacity" {
  description = "Ideal number of instances in the ECS cluster."
}
variable "instance_type" {
  description = "Size of instances in the ECS cluster."
}
variable "tags" {
  description = "Resource Tags"
}
variable "jenkins_ecs_cluster_name" {
  description = "Name of the ECS cluster name"
}

# A name to describe the environment we're creating.
environment = "prod"


# A name to describe the environment we're creating.
name_prefix = "jenkins-agent"

# The AWS-CLI profile for the account to create resources in.
aws_profile = "default"

# The AWS region to create resources in.
aws_region = "us-west-2"

# The AMI to seed ECS instances with.
# Leave empty to use the latest Linux 2 ECS-optimized AMI by Amazon.
aws_ecs_ami = ""

# The IP range to attribute to the virtual network.
# The allowed block size is between a /16 (65,536 addresses) and /28 (16 addresses).
vpc_cidr = "10.0.0.0/16"

# The IP ranges to use for the public subnets in your VPC.
# Must be within the IP range of your VPC.
public_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]

# The IP ranges to use for the private subnets in your VPC.
# Must be within the IP range of your VPC.
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# The AWS availability zones to create subnets in.
# For high-availability, we need at least two.
availability_zones = ["us-west-2a", "us-west-2b"]

# Maximum number of instances in the ECS cluster.
max_size = 1

# Minimum number of instances in the ECS cluster.
min_size = 1

# Ideal number of instances in the ECS cluster.
desired_capacity = 1

# Size of instances in the ECS cluster.
instance_type = "t2.medium"

# Name of the ECS cluster for running Master Jenkins
jenkins_ecs_cluster_name = "jenkins-controller"

tags = {
  team        = "ruo"
  solution    = "jenkins"
  project  = "ruo-jenkins"
}

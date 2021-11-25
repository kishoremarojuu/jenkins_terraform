terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    profile = "871244369079MasterController"   #CHANGEME
    bucket  = "jenkins-ivd-integration" #CHANGEME
    region  = "us-west-2"
    key     = "jenkinsFargateAgentKey"
    encrypt = true

  }
}

# Configure default AWS Provider
provider "aws" {
  profile                 = "default" #CHANGEME
  region                  = "us-west-2"
  skip_metadata_api_check = true
    assume_role {
    role_arn = "arn:aws:iam::156938468557:role/Administrator"
  }
}



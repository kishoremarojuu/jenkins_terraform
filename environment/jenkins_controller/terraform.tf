terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    profile = "jenkins-controller"   #CHANGEME
    bucket  = "jenkins-poc-tf-state" #CHANGEME
    region  = "us-west-2"
    key     = "poc"
    encrypt = true
  }
}

# Configure default AWS Provider
provider "aws" {
  profile                 = "jenkins-controller" #CHANGEME
  region                  = "us-west-2"
  skip_metadata_api_check = true
}

# Configure other AWS Providers
provider "aws" {
  profile                 = "jenkins-controller" #CHANGEME
  region                  = "us-west-2"
  alias                   = "jenkins-controller"
  skip_metadata_api_check = true
}

provider "aws" {
  profile                 = "jenkins-agent1" #CHANGEME
  region                  = "us-west-2"
  alias                   = "jenkins-agent"
  skip_metadata_api_check = true
}
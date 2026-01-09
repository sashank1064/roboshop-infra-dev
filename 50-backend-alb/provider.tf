terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.24.0"
    }
  }
}

terraform {


  backend "s3" {
    bucket       = "84s-remote-state-devv"
    key          = "roboshop-dev-backend-alb"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
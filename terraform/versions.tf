terraform {
  required_version = "~> 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.42.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.111.0"
    }
  }
}

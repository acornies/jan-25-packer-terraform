variable "cidr_vpc_east" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "cidr_subnet_east" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

variable "region_east" {
  description = "The default region where Terraform deploys your resources"
  default     = "us-east-2"
}

variable "hcp_packer_bucket" {
  description = "HCP Packer bucket name for base golden image"
  default     = "learn-packer-hcp-hashicups-image"
}

variable "hcp_packer_channel" {
  description = "HCP Packer channel name"
  default     = "production"
}

variable "key_name" {
  description = "The name of the AWS key pair to use for SSH access to the EC2 instances"
  default     = "packer-demo"
}


# make a variable that for backend_servers a map of any type
variable "backend_servers" {
    description = "A list of backend servers"
    type        = map(any)
    default = {
        "learn-packer-jan25-backend-server01" = {}
        "learn-packer-jan25-backend-server02" = {}
    }
}
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
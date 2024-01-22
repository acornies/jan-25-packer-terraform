packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "version" {
  type    = string
  default = "1.0.0"
}

data "amazon-ami" "ubuntu-jammy-east" {
  region = "us-east-2"
  filters = {
    name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  }
  most_recent = true
  owners      = ["amazon"]
}

source "amazon-ebs" "ubuntu-jammy-east-base" {
  region         = "us-east-2"
  source_ami     = data.amazon-ami.ubuntu-jammy-east.id
  instance_type  = "t2.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false
  ami_name       = "packer_ubuntu_base_{{timestamp}}_v${var.version}"
}

build {
  hcp_packer_registry {
    bucket_name = "jan25-ubuntu-base"
    description = <<EOT
Some nice description about the image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "owner"          = "platform-team"
      "os"             = "Ubuntu",
      "ubuntu-version" = "Jammy 22.04",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }
  sources = [
    "source.amazon-ebs.ubuntu-jammy-east-base"
  ]
}
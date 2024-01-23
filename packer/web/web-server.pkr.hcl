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
  default = "1.0.3"
}

data "hcp-packer-iteration" "base-image" {
  bucket_name = "jan25-ubuntu-base"
  channel     = "production"
}

data "hcp-packer-image" "base-image-aws-east" {
  bucket_name    = "jan25-ubuntu-base"
  iteration_id   = data.hcp-packer-iteration.base-image.id
  cloud_provider = "aws"
  region         = "us-east-2"
}

source "amazon-ebs" "ubuntu-web-server-east" {
  region         = "us-east-2"
  source_ami     = data.hcp-packer-image.base-image-aws-east.id
  instance_type  = "t2.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false
  ami_name       = "packer_ubuntu_webserver_{{timestamp}}_v${var.version}"
}

build {
  hcp_packer_registry {
    bucket_name = "jan25-web-server"
    description = <<EOT
Some nice description about the image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "owner"           = "application-team"
      "os"              = "Ubuntu",
      "ubuntu-version"  = "Jammy 22.04",
      "web-server-type" = "nginx"
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo cp /tmp/index.html /var/www/html/index.html",
      "sudo systemctl start nginx"
    ]
  }

  sources = [
    "source.amazon-ebs.ubuntu-web-server-east"
  ]
}
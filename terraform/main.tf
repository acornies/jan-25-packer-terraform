provider "aws" {
  region = var.region_east
}

provider "hcp" {}

data "hcp_packer_version" "web_servers" {
  bucket_name  = var.hcp_packer_bucket
  channel_name = var.hcp_packer_channel
}

data "hcp_packer_artifact" "web_servers" {
  bucket_name = data.hcp_packer_version.web_servers.bucket_name
  # iteration_id   = data.hcp_packer_version.web_servers.ulid
  version_fingerprint = data.hcp_packer_version.web_servers.fingerprint
  platform            = "aws"
  region              = var.region_east
}

# packer channel example
resource "aws_instance" "web_servers_frontend" {
  for_each      = var.frontend_servers
  ami           = data.hcp_packer_artifact.web_servers.external_identifier
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_public_east.id
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh_east.id,
    aws_security_group.allow_egress_east.id,
    aws_security_group.http_east.id,
    aws_security_group.ldap_east.id
  ]
  associate_public_ip_address = true

  tags = {
    Name        = each.key
    Environment = var.environment_tag
  }

  # uncomment if you want to use this during plan phase
  #   lifecycle {
  #     precondition {
  #       condition = data.hcp_packer_artifact.web_servers.revoke_at == null
  #       error_message = "Source AMI is revoked."
  #     }
  #   }

}

check "revoke_check" {
  assert {
    condition     = data.hcp_packer_artifact.web_servers.revoke_at == null
    error_message = "Source AMI is revoked."
  }
}

# harded coded ami example
# resource "aws_instance" "web_servers_backend" {
#   for_each      = var.backend_servers
#   ami           = "ami-04a70e396066716f2"
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.subnet_public_east.id
#   key_name      = var.key_name
#   vpc_security_group_ids = [
#     aws_security_group.ssh_east.id,
#     aws_security_group.allow_egress_east.id
#   ]
#   associate_public_ip_address = false

#   tags = {
#     Name = each.key
#   }
# }
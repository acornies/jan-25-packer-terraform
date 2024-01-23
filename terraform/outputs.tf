output "frontend_ips" {
  value = {
    for k, v in aws_instance.web_servers_frontend : k => v.public_ip
  }
  description = "Public IP address for the nginx web server instance."
}
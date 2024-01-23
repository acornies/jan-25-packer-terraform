output "webserver_ip" {
  value       = aws_instance.web_servers_packer.public_ip
  description = "Public IP address for the nginx web server instance."
}
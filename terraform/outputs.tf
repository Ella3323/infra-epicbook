# Only non-sensitive values. Never output passwords, keys or secrets.
output "app_public_ip" {
  description = "Frontend public IP - open http://<this> in a browser"
  value       = aws_instance.frontend.public_ip
}

output "backend_ansible_host" {
  description = "Backend address Ansible uses for SSH (management only)"
  value       = aws_instance.backend.public_ip
}

output "backend_private_ip" {
  description = "Backend private IP - Nginx proxies application traffic here"
  value       = aws_instance.backend.private_ip
}

output "mysql_fqdn" {
  description = "Private RDS MySQL hostname"
  value       = aws_db_instance.mysql.address
}

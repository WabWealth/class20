output "java_node_public_ip" {
  description = "Public IP for Node 1 (JDK) — put under [app] in Ansible inventory."
  value       = aws_instance.java_node.public_ip
}

output "nginx_node_public_ip" {
  description = "Public IP for Node 2 (Nginx) — put under [web] in Ansible inventory."
  value       = aws_instance.nginx_node.public_ip
}

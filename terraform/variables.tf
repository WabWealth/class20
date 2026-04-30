variable "aws_region" {
  description = "AWS region where resources are created."
  type        = string
  default     = "eu-west-1"
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair in AWS (you download the .pem once). Ansible/GitHub Actions uses the matching private key."
  type        = string
}

variable "instance_type" {
  description = "Size for both VMs (small is enough for class)."
  type        = string
  default     = "t3.micro"
}

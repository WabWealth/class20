# --- Default VPC (simplest path for class; no custom VPC required) ---
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Amazon Linux 2023 (works with yum in your Ansible playbook)
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]
  }
}

# One security group for both nodes: SSH for Ansible, HTTP for Nginx on node 2
resource "aws_security_group" "nodes" {
  name        = "class20-nodes-sg"
  description = "SSH + HTTP for class assignment"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from anywhere (OK for labs; tighten for production)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP for Nginx"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "class20-nodes-sg"
  }
}

# Node 1: Java / app (Ansible group [app])
resource "aws_instance" "java_node" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = sort(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids      = [aws_security_group.nodes.id]
  associate_public_ip_address = true

  tags = {
    Name = "class20-java-node"
    Role = "app"
  }
}

# Node 2: Nginx / web (Ansible group [web])
resource "aws_instance" "nginx_node" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = sort(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids      = [aws_security_group.nodes.id]
  associate_public_ip_address = true

  tags = {
    Name = "class20-nginx-node"
    Role = "web"
  }
}

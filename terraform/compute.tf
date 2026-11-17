data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${local.name}-key"
  public_key = file("${path.module}/${var.ssh_public_key_file}")
}

resource "aws_instance" "frontend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.frontend.id
  vpc_security_group_ids      = [aws_security_group.frontend.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required" # IMDSv2 only
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = "${local.name}-frontend", Role = "frontend" }

  # Don't replace the VM (and change its IPs) just because Canonical published a newer AMI
  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_instance" "backend" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.backend.id
  vpc_security_group_ids      = [aws_security_group.backend.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true # management (Ansible SSH) only - app port is not public

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 12
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = "${local.name}-backend", Role = "backend" }

  lifecycle {
    ignore_changes = [ami]
  }
}

# Frontend: HTTP open to the world, SSH only from approved sources
resource "aws_security_group" "frontend" {
  name        = "${local.name}-frontend-sg"
  description = "Frontend: public HTTP, restricted SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from admin / pipeline agent"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_cidrs
  }

  egress {
    description = "All outbound (package installs, proxy to backend)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-frontend-sg" }
}

# Backend: SSH from approved sources, app port ONLY from the frontend SG
resource "aws_security_group" "backend" {
  name        = "${local.name}-backend-sg"
  description = "Backend: app port from frontend only, restricted SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from admin / pipeline agent"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_cidrs
  }

  ingress {
    description     = "EpicBook app port from frontend tier only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    description = "All outbound (npm, apt, MySQL)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-backend-sg" }
}

# Database: MySQL ONLY from the backend SG. No egress rules needed.
resource "aws_security_group" "database" {
  name        = "${local.name}-db-sg"
  description = "Database: MySQL from backend tier only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from backend tier only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  tags = { Name = "${local.name}-db-sg" }
}

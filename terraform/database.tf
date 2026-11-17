resource "aws_db_subnet_group" "main" {
  name       = "${local.name}-db-subnets"
  subnet_ids = aws_subnet.database[*].id
  tags       = { Name = "${local.name}-db-subnets" }
}

resource "aws_db_instance" "mysql" {
  identifier     = "${local.name}-mysql"
  engine         = "mysql"
  engine_version = var.mysql_engine_version
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_admin_username
  password = var.db_admin_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false # private access only
  multi_az               = false

  backup_retention_period    = 0 # lab: avoids free-tier backup restriction
  skip_final_snapshot        = true
  deletion_protection        = false
  apply_immediately          = true
  auto_minor_version_upgrade = true

  tags = { Name = "${local.name}-mysql" }
}

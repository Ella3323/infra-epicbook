# Non-sensitive values only. Committed to Git on purpose.
# db_admin_username / db_admin_password are NEVER here:
# locally they come from TF_VAR_ env vars, in the pipeline from the secret variable group.
aws_region           = "us-east-1"
project_name         = "epicbook-a04"
owner                = "Ella"
vpc_cidr             = "10.20.0.0/16"
frontend_subnet_cidr = "10.20.1.0/24"
backend_subnet_cidr  = "10.20.2.0/24"
db_subnet_cidrs      = ["10.20.11.0/24", "10.20.12.0/24"]
instance_type        = "t3.micro"
ssh_public_key_file  = "epicbook-aws-key.pub"
app_port             = 8080
db_name              = "bookstore"
db_instance_class    = "db.t3.micro"
mysql_engine_version = "8.0"
admin_cidrs          = ["102.90.96.70/32"]

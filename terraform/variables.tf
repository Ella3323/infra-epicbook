variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "epicbook"
}

variable "owner" {
  description = "Owner tag"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC address range"
  type        = string
  default     = "10.20.0.0/16"
}

variable "frontend_subnet_cidr" {
  description = "Frontend (Nginx) subnet"
  type        = string
}

variable "backend_subnet_cidr" {
  description = "Backend (EpicBook) subnet"
  type        = string
}

variable "db_subnet_cidrs" {
  description = "Two private database subnets in different AZs (RDS requires two)"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 size for both VMs"
  type        = string
  default     = "t3.micro"
}

variable "ssh_public_key_file" {
  description = "Public key file, relative to this terraform/ directory"
  type        = string
}

variable "admin_cidrs" {
  description = "Sources allowed to SSH: your public IP /32 (also the self-hosted agent's IP)"
  type        = list(string)

  validation {
    condition     = length(var.admin_cidrs) > 0 && !contains(var.admin_cidrs, "0.0.0.0/0")
    error_message = "admin_cidrs must list at least one specific CIDR and must never be 0.0.0.0/0."
  }
}

variable "app_port" {
  description = "Port EpicBook listens on (backend VM)"
  type        = number
  default     = 8080
}

variable "db_name" {
  description = "Application database name"
  type        = string
  default     = "bookstore"
}

variable "db_instance_class" {
  description = "RDS instance size"
  type        = string
  default     = "db.t3.micro"
}

variable "mysql_engine_version" {
  description = "MySQL major version (RDS picks the current default minor)"
  type        = string
  default     = "8.0"
}

variable "db_admin_username" {
  description = "RDS admin username - supplied via TF_VAR_db_admin_username, never committed"
  type        = string
  sensitive   = true
}

variable "db_admin_password" {
  description = "RDS admin password - supplied via TF_VAR_db_admin_password, never committed"
  type        = string
  sensitive   = true
}

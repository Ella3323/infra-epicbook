data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name = var.project_name
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "${local.name}-vpc" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${local.name}-igw" }
}

# --- Frontend tier: public web entry point ---
resource "aws_subnet" "frontend" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.frontend_subnet_cidr
  availability_zone = local.azs[0]
  tags              = { Name = "${local.name}-frontend-subnet", Tier = "frontend" }
}

# --- Backend tier: routed to the internet ONLY so Ansible can reach it over SSH
# (lab compromise allowed by the assignment). The app port is NOT public -
# see the backend security group.
resource "aws_subnet" "backend" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.backend_subnet_cidr
  availability_zone = local.azs[0]
  tags              = { Name = "${local.name}-backend-subnet", Tier = "backend" }
}

# --- Database tier: private, no internet route at all ---
resource "aws_subnet" "database" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  tags              = { Name = "${local.name}-db-subnet-${count.index + 1}", Tier = "database" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { Name = "${local.name}-public-rt" }
}

resource "aws_route_table_association" "frontend" {
  subnet_id      = aws_subnet.frontend.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "backend" {
  subnet_id      = aws_subnet.backend.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${local.name}-db-rt" }
}

resource "aws_route_table_association" "database" {
  count          = 2
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

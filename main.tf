resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_tenancy
  tags = {
    Name = "main"
  }
}

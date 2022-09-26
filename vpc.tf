resource "aws_vpc" "demo" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name        = "demoVpc"
    Environment = "${terraform.workspace}"
  }
}

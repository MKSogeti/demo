provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "terraform-backend-658fs6tskhigrg5566a85"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "backend-tf"
  }
}

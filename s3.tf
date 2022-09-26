#s3 bucket storing ALB access logs

locals {
  alb_root_account_id = "127311923021" # valid account id for us-east-1 Region. 
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.demo_s3_bucket
  # //acl    = "private"
  # //region = var.region
  tags = {
    Name        = "demo-app-de"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = "demo-hctra-alb-access-logs"
  policy = data.template_file.demo.rendered
  # //acl    = "private"
  # //region = var.region
  tags = {
    Name        = "demo-access-logs"
    Environment = "${terraform.workspace}"
  }
}

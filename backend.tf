terraform {
  backend "s3" {
    bucket  = "terraform-state-cloudfront"
    key     = "cloudfront/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

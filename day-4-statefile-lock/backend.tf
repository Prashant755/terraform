terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state-105"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    
  }
}
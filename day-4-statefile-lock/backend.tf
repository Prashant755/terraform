terraform {
  backend "s3" {
    bucket         = "my-company-terraform-state-105"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true # s3 natively supports state locking, so this is optional
    #dynamodb_table = "terraform-state-lock"   
  }
}
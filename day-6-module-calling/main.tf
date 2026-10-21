module "dev" {  
  source = "../day-6-modules"
cidr_block        = "10.0.0.0/16"
subnet_cidr_block = "10.0.0.0/24"
bucket_name       = "my-bucket-1699105-prashant-dev"
environment       = "Dev"
ssh_cidr_blocks   = ["0.0.0.0/0"]
region            = "us-east-1"
ami_id            = "ami-0567589d25e06853e"
instance_type     = "t3.micro"
instance_name     = "my-server-dev"
subnet_name        = "my-subnet-dev"
availability_zone  = "us-east-1a"
vpc_name          = "my-vpc-dev"

}


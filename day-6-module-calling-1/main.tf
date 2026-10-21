module "test" {
    source = "../day-6-modules"
  cidr_block        = "20.0.0.0/16"
subnet_cidr_block = "20.0.0.0/24"
bucket_name       = "my-bucket-1699105-test"
environment       = "test"
ssh_cidr_blocks   = ["0.0.0.0/0"]
region            = "us-west-2"
ami_id            = "ami-0803a33fd43db1fbf"
instance_type     = "t2.micro"
instance_name     = "my-server-test"
subnet_name        = "my-subnet-test"
availability_zone  = "us-west-2a"
vpc_name          = "my-vpc-test"
}
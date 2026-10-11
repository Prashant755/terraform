resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
    region = "us-west-2"
      }
}

## here VPC is created with the name "my-vpc" and the CIDR block "  
## resource
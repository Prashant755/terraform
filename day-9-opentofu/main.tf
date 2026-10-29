provider "aws" {
   region = "us-east-1"
}
resource "aws_instance" "ec2" {
   ami           = "ami-041607313c6a2a618"
   instance_type = "t2.micro"   
   tags = {
      Name = "new-ec2-tufo-EC2"
   }
}


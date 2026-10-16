resource "aws_instance" "ec2-server" {
  ami           = "ami-08c982207dfbf2b27"
  instance_type = "t2.medium"
  tags = {
    Name = "ec2-server-prashant" }
}



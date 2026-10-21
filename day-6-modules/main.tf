resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr_block
  region     = var.region
  tags = {
    Name = var.vpc_name
  }

}
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.subnet_cidr_block
  region     = var.region
  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  region = var.region
  tags = {
    Name = var.igw_name
  }
}
resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id
  region = var.region
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = var.route_table_name
  }
}
resource "aws_route_table_association" "my-rtassociation" {
  region         = var.region
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.my-rt.id
}
resource "aws_security_group" "my-sg" {
  name        = var.sg_name
  description = var.sg_description
  region      = var.region
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "my-instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet-1.id
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  region                = var.region
  tags = {
    Name = var.instance_name
  }
}
resource "aws_s3_bucket" "my-bucket-1699105" {
  bucket = var.bucket_name
  region = var.region
  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
} 



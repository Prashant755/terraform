provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "dev-subnet-1"
  }
}

resource "aws_internet_gateway" "igw_dev" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "dev-rt" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_dev.id
  }

  tags = {
    Name = "dev-rt"
  }
}

resource "aws_route_table_association" "dev-rtassociation" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.dev-rt.id
}

resource "aws_security_group" "dev-sg" {
  name        = "dev-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.dev.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev-instance" {
  ami                    = "ami-0fa60bddfa021e69f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-1.id
  vpc_security_group_ids = [aws_security_group.dev-sg.id]
  
  tags = {
    Name = "dev-server"
  }

  lifecycle {
    create_before_destroy = true
  }
}
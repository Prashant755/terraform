resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
  
}
resource "aws_subnet" "subnet-1"{
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "my-subnet-1"
    }
}

resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "my-igw"
    }
}
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
    tags = {
        Name = "my-rt"
    }
}
resource "aws_route_table_association" "my-rtassociation" {
    subnet_id = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.my-rt.id
}
resource "aws_security_group" "my-sg" {
    name = "my-sg"
    description = "Allow SSH and HTTP"
    vpc_id = aws_vpc.my-vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
  
resource "aws_instance" "my-instance" {
    ami = "ami-0803a33fd43db1fbf"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet-1.id
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    tags = {
        Name = "my-server"
    }
}

resource "aws_s3_bucket" "my-bucket-1699105" {
  bucket = "my-bucket-1699105"
   tags = {
    Name        = "my-bucket-1699105"
    Environment = "Dev"
  }
} 


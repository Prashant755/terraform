resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "dev" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet1_cidr
  tags = {
    Name = "dev-subnet"
  }
}
resource "aws_subnet" "test" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet2_cidr
  tags = {
    Name = "test-subnet"
  }
}


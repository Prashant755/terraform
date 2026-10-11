output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}
output "subnet2_cidr" {
  value = aws_subnet.test.cidr_block
}
output "subnet1_az" {
  value = aws_subnet.dev.availability_zone
}
output "subnet2_az" {
  value = aws_subnet.test.availability_zone
}
output "vpc_tags" {
  value = aws_vpc.main
}
output "subnet1_id" {
  value = aws_subnet.dev.id
}
output "subnet2_id" {
  value = aws_subnet.test.id
}


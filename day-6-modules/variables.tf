variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = ""
}

variable "subnet_name" {
  description = "Name tag for the subnet"
  type        = string
  default     = "my-subnet-1"
}

variable "igw_name" {
  description = "Name tag for the internet gateway"
  type        = string
  default     = "my-igw"
}

variable "route_table_name" {
  description = "Name tag for the route table"
  type        = string
  default     = "my-rt"
}

variable "sg_name" {
  description = "Name for the security group"
  type        = string
  default     = "my-sg"
}

variable "sg_description" {
  description = "Description for the security group"
  type        = string
  default     = "Allow SSH and HTTP"
}

variable "ssh_port" {
  description = "Port for SSH access"
  type        = number
  default     = 22
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0803a33fd43db1fbf"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "my-server"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment tag for resources"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = ""
  }

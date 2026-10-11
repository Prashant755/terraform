variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.2.0/24"
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "main-vpc"
}

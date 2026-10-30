
variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  default     = "30-10-26"
}

variable "private_key_path" {
  description = "Local path of PEM file on Terraform machine"
  default     = "~/.ssh/my-key.pem"
}

variable "ec2_ami" {
  description = "Amazon Linux 2 AMI in us-east-1"
  default     = "ami-0c02fb55956c7d316"
}

variable "mysql_engine_version" {
  description = "Supported MySQL RDS engine version"
  default     = "8.0"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "ssh_allowed_cidrs" {
  description = "Your public IP in CIDR format"
  type        = list(string)
  default     = ["YOUR_PUBLIC_IP/32"]
}

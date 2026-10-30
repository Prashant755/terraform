
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get public subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "sql-runner-sg"
  description = "Allow SSH access to SQL runner"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access - restrict to your IP in production"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sql-runner-sg"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "mysql-rds-sg"
  description = "Allow MySQL access from EC2"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql-rds-sg"
  }
}

# EC2 Instance
resource "aws_instance" "sql_runner" {
  ami                         = var.ec2_ami
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "SQL-Runner"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql_rds" {
  identifier             = "my-mysql-db"
  engine                 = "mysql"
  engine_version         = var.mysql_engine_version
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = var.db_password
  db_name                = "dev"
  allocated_storage      = 20
  storage_type           = "gp3"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "MySQL-RDS"
  }
}

# Execute SQL remotely on EC2
resource "null_resource" "remote_sql_exec" {

  depends_on = [
    aws_db_instance.mysql_rds,
    aws_instance.sql_runner
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(pathexpand(var.private_key_path))
    host        = aws_instance.sql_runner.public_ip
    timeout     = "5m"
  }

  # Copy SQL file to EC2
  provisioner "file" {
    source      = "${path.module}/init.sql"
    destination = "/tmp/init.sql"
  }

  # Execute SQL script
  provisioner "remote-exec" {
    inline = [
      "sudo yum install mariadb105 -y || sudo yum install mariadb -y",

      "mysql --version",

      "until mysqladmin ping -h ${aws_db_instance.mysql_rds.address} -u admin -p'${var.db_password}' --silent; do sleep 10; done",

      "MYSQL_PWD='${var.db_password}' mysql -h ${aws_db_instance.mysql_rds.address} -u admin dev < /tmp/init.sql",

      "echo 'SQL initialization completed successfully'"
    ]
  }

  triggers = {
    sql_file = filemd5("${path.module}/init.sql")
    rds_id   = aws_db_instance.mysql_rds.id
    ec2_id   = aws_instance.sql_runner.id
  }
}

# Outputs
output "ec2_public_ip" {
  value = aws_instance.sql_runner.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql_rds.address
}

output "database_name" {
  value = aws_db_instance.mysql_rds.db_name
}

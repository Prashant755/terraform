/*module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket-prashant-dev"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
*/
#########################################################################
/*module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-Prashant-instance"

  instance_type = "t2.micro"
 # key_name      = "user1"
  monitoring    = true
  subnet_id     = "subnet-0804f98850a51a7c2"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
*/
############################################################################
/* # IAM User Module
module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 5.0"

  name          = "Prashant-Dev-User"
  force_destroy = true

  # Set to true if the user needs to log into the AWS Management Console
  create_iam_user_login_profile = true
  password_reset_required       = true

  # Set to true if the user/application needs programmatic API Access Keys
  create_iam_access_key         = true
}
data "aws_iam_policy_document" "s3_full_access" {
  statement {
    sid       = "S3FullAccess"
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}
# Outputs to safely capture generated credentials
output "user_arn" {
  value = module.iam_user.iam_user_arn
}

output "access_key_id" {
  value = module.iam_user.iam_access_key_id
}

# IAM policy creation for S3 full access
# 2. Create the Custom IAM Policy resource using the data source JSON
resource "aws_iam_policy" "s3_full_access" {
  name        = "S3FullAccessPolicy-Prashant-Dev"
  path        = "/"
  description = "IAM policy providing full S3 access for user Prashant-Dev-User."
  policy      = data.aws_iam_policy_document.s3_full_access.json
}

# 3. Attach the Policy directly to the module user
resource "aws_iam_user_policy_attachment" "attach_s3_full_access" {
  user       = module.iam_user.iam_user_name
  policy_arn = aws_iam_policy.s3_full_access.arn
}*/
#################################################################################

# 1. Create IAM user
module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 5.0"

  name = "Prashant-Prod-User"

  create_iam_user_login_profile = true
  password_reset_required       = true

  create_iam_access_key = true
}

# 2. Create customer-managed IAM policy
module "s3_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.0"

  name        = "S3FullAccessPolicy-Prashant-Prod-user"
  description = "Full S3 access policy for production"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = ["*"]
      }
    ]
  })
}

# 3. Attach policy to IAM user
resource "aws_iam_user_policy_attachment" "s3_full_access" {
  user       = module.iam_user.iam_user_name
  policy_arn = module.s3_policy.arn
}
#################################################################################

# Create EC2 SSM IAM role and instance profile
module "ec2_ssm_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 6.0"

  name        = "EC2-SSM-Role"
  description = "IAM role for EC2 Systems Manager access"

  # Allow EC2 to assume this role
  trust_policy_permissions = {
    EC2AssumeRole = {
      actions = ["sts:AssumeRole"]

      principals = [{
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]
    }
  }

  # Create an instance profile for EC2
  create_instance_profile = true

  # Attach the AWS-managed SSM policy
  policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Display role ARN
output "ssm_role_arn" {
  description = "ARN of the EC2 SSM IAM role"
  value       = module.ec2_ssm_role.arn
}

# Display instance profile name
output "ssm_instance_profile_name" {
  description = "Instance profile name to associate with EC2"
  value       = module.ec2_ssm_role.instance_profile_name
}
##############################################################################

# Create EC2 instance and attach SSM role
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name          = "Prashant-SSM-Instance"
  instance_type = "t2.micro"

  # Replace with a valid AMI ID in your AWS region
  ami = "ami-0c55b159cbfafe1f0"

  # Replace with your existing subnet ID
  subnet_id = "subnet-0804f98850a51a7c2"

  # Attach the instance profile created by the IAM role module
  iam_instance_profile = module.ec2_ssm_role.instance_profile_name

  # Enable detailed monitoring if required
  monitoring = false

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }

  depends_on = [
    module.ec2_ssm_role
  ]
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.id
}

output "ec2_public_ip" {
  description = "Public IP address, if assigned"
  value       = module.ec2_instance.public_ip
}
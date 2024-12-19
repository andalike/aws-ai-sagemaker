
//Create an IAM user
resource "aws_iam_user" "example" {
  name = provider::aws::arn_builder("iamaws2006")
}

//Create an IAM policy
resource "aws_iam_policy" "example" {
  name        = "example-policy"
  description = "Example policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:*"
        Resource = "*"
        Effect = "Allow"
      }
    ]
  })
}

//Attach the IAM policy to the IAM user
resource "aws_iam_user_policy_attachment" "example" {
  user       = aws_iam_user.example.name
  policy_arn = aws_iam_policy.example.arn
}


//S3 Resources
//Create an S3 bucket
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


//Route 53 Resources
//Create a Route 53 hosted zone
resource "aws_route53_zone" "example" {
  name = "example.com"
}

//Create a Route 53 record set
resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "example.com"
  type    = "A"
  alias {
    name                   = aws_s3_bucket.example.website_endpoint
    zone_id                = aws_s3_bucket.example.zone_id
    evaluate_target_health = false
  }
}


//SNS Resources
//Create an SNS topic
resource "aws_sns_topic" "example" {
  name = "example-topic"
}

///Create an SNS subscription
resource "aws_sns_topic_subscription" "example" {
  topic_arn = aws_sns_topic.example.arn
  protocol   = "email"
  endpoint   = "example@example.com"
}


//MySQL Resources
////Create a MySQL database instance
resource "aws_db_instance" "example" {
  identifier           = "example-db"
  instance_class        = "db.t2.micro"
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = "exampleuser"
  password               = "examplepassword"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.example.id]
}

//Create a security group for the MySQL instance
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow inbound traffic on port 3306"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//KMS Resources
//Create a KMS key
resource "aws_kms_key" "example" {
  description             = "Example KMS key"
  deletion_window_in_days = 10
}

//Create a KMS alias
resource "aws_kms_alias" "example" {
  name          = "alias/example-key"
  target_key_id = aws_kms_key.example.key_id
}

// SageMaker Resources
resource "aws_sagemaker_notebook_instance" "example" {
  name                 = "example-notebook-instance"
  instance_type        = "ml.t2.medium"
  role_arn             = aws_iam_role.sagemaker_execution_role.arn
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.example.name
}

// IAM Role for SageMaker
resource "aws_iam_role" "sagemaker_execution_role" {
  name = "sagemaker-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

// Attach policies to the role
resource "aws_iam_role_policy_attachment" "sagemaker_execution_policy" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "example" {
  name = "example-lifecycle-config"

  on_create = <<EOF
#!/bin/bash
set -e
# Add your on-create script here
EOF

  on_start = <<EOF
#!/bin/bash
set -e
# Add your on-start script here
EOF
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC Configuration
resource "aws_vpc" "devforge_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "devforge-vpc"
    Environment = "Production"
  }
}

# DynamoDB Table
resource "aws_dynamodb_table" "architecture_table" {
  name           = "DevForgeArchitectures"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Lambda Function for Analysis
resource "aws_lambda_function" "analyze_func" {
  filename      = "function.zip"
  function_name = "devforge-analyze"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

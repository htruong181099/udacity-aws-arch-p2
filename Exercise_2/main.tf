provider "aws" {
    profile= "default"
    region= var.aws_region
}

data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = var.output_archive_name
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "greet_lambda" {
    filename= data.archive_file.lambda_zip.output_path
    function_name= var.lambda_function_name
    handler= var.lambda_handler
    role=aws_iam_role.lambda_iam_role.arn
    runtime = var.lambda_runtime

    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    depends_on = [aws_iam_role_policy_attachment.lambda_logs]

  environment {
    variables = {
      greeting = "Hello Udacity!"
    }
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
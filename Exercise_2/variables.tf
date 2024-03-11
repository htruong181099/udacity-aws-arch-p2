# TODO: Define the variable for aws_region
variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "lambda_runtime" {
  type = string
  default = "python3.9"
}

variable "lambda_function_name" {
  type = string
  default = "greet_lambda"
}

variable "lambda_handler" {
  type = string
  default = "greet_lambda.lambda_handler"
}

variable "output_archive_name" {
  type = string
  default = "greet_lambda.zip"
}



data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_role_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.mjs"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "blue_green_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "blue_green_deployment_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.handler"
  publish       = true

  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "nodejs20.x"
}

resource "aws_lambda_alias" "blue_green_lambda_prod_alias" {
  name             = "prod"
  description      = "the prod alias"
  function_name    = aws_lambda_function.blue_green_lambda.arn
  function_version = "2"

  routing_config {
    additional_version_weights = {
      "1" = 0.0
    }
  }
  depends_on = [
    aws_lambda_function.blue_green_lambda
  ]
}

resource "aws_lambda_function_url" "blue_green_lambda_url" {
  function_name      = aws_lambda_function.blue_green_lambda.function_name
  qualifier          = "prod"
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
  depends_on = [
    aws_lambda_function.blue_green_lambda, aws_lambda_alias.blue_green_lambda_prod_alias
  ]
}


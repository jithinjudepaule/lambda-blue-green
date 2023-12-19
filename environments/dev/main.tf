

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

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_blue_green_deployment"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.handler"
  publish       = true

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs20.x"


}

resource "aws_lambda_alias" "test_lambda_prod_alias" {
  name             = "prod"
  description      = "the prod alias"
  function_name    = aws_lambda_function.test_lambda.arn
  function_version = "1"

  routing_config {
    additional_version_weights = {
      "2" = 0.5
    }
  }
  depends_on = [
    aws_lambda_function.test_lambda
  ]
}

resource "aws_lambda_function_url" "test_lambda_url" {
  function_name      = aws_lambda_function.test_lambda.function_name
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
    aws_lambda_function.test_lambda, aws_lambda_alias.test_lambda_prod_alias
  ]
}


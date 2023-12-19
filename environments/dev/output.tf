output "lambda_function_version" {
  value = aws_lambda_function.test_lambda.version
}

# output "lambda_function_last_modified"{
#     value = aws_lambda_function.test_lambda.lambda_function_last_modified
# }
# Provide permissions to write to Cloudwatch logs.
# AWSLambdaBasicExecutionRole is managed by AWS.
data "aws_iam_policy" "write_to_cloudwatch_logs_permission_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}





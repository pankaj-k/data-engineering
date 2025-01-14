# The AWS Lambda service (lambda.amazonaws.com) is given permission to assume an IAM role.
# The specific role that Lambda is allowed to assume will be the IAM role that this policy is attached to.
data "aws_iam_policy_document" "allow_aws_lambda_service_to_assume_role" {
  statement {
    sid     = "1"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Provide permissions to write to Cloudwatch logs.
# AWSLambdaBasicExecutionRole is managed by AWS.
data "aws_iam_policy" "write_to_cloudwatch_logs_permission_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}





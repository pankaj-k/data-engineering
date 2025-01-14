# Create role used all through the project. 
# For start allow the AWS Lambda service to assume the role via the policy document allow_aws_lambda_service_to_assume_role
# defined in lambda_iam.tf
resource "aws_iam_role" "data_engg_role" {
  name               = "data_engg_role"
  assume_role_policy = data.aws_iam_policy_document.allow_aws_lambda_service_to_assume_role.json
}

# Add S3 access role to it.
# The policy is defined in s3_iam.tf
resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
  role       = aws_iam_role.data_engg_role.name
  policy_arn = aws_iam_policy.s3_aws_iam_policy.arn
}

# Attach the write to cloudwatch logs policy to the role.
# defined in lambda_iam.tf
resource "aws_iam_role_policy_attachment" "write_to_cloudwatch_logs_permission_policy_attachment" {
  role       = aws_iam_role.data_engg_role.name
  policy_arn = data.aws_iam_policy.write_to_cloudwatch_logs_permission_policy.arn
}

# Attach the glue policy to the role.   
# defined in glue_iam.tf
resource "aws_iam_role_policy_attachment" "attach_glue_policy" {
  role       = aws_iam_role.data_engg_role.name
  policy_arn = aws_iam_policy.glue_aws_iam_policy.arn
}

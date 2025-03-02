# The AWS Glue service (glue.amazonaws.com) is given permission to assume an IAM role.
# The specific role that Glue is allowed to assume will be the IAM role that this policy is attached to.
data "aws_iam_policy_document" "allow_aws_glue_service_to_assume_role" {
  statement {
    sid     = "1"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

# This one is too permissive. It allows glue to do run all its operations on all resources.
# data "aws_iam_policy_document" "s3_glue_policy_document" {
#   statement {
#     sid = "1"
#     actions = [
#       "glue:*", # Need to fine tune the permissions.
#     ]
#     resources = ["*"]
#   }
# }


# resource "aws_iam_policy" "glue_aws_iam_policy" {
#   name   = "glue_aws_iam_policy"
#   path   = "/"
#   policy = data.aws_iam_policy_document.s3_glue_policy_document.json
# }

# Provide permissions to glue to access common aws services which it uses while doing work.
# AWSGlueServiceRole is managed by AWS.
# If your use case aligns with typical Glue operations, using the AWS-managed policy 
# (AWSGlueServiceRole) is often sufficient and follows AWS security best practices.
data "aws_iam_policy" "glue_access_to_aws_services_permission_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

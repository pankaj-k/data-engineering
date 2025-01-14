data "aws_iam_policy_document" "s3_glue_policy_document" {
  statement {
    sid = "1"
    actions = [
      "glue:*", # Need to fine tune the permissions.
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "glue_aws_iam_policy" {
  name   = "glue_aws_iam_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_glue_policy_document.json
}

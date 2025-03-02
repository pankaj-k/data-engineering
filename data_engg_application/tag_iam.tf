# Lambda function to reads the tags of the S3 bucket to find the right buckets. 
# This policy provides the permission to read tags and is attached to the role that the Lambda function assumes.
data "aws_iam_policy_document" "tag_iam_access_policy_document" {
  statement {
    sid = "1"
    actions = [
      "tag:GetResources",
      "tag:TagResources",
      "tag:UntagResources",
      "tag:getTagKeys",
      "tag:getTagValues",
      "resource-explorer:List*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "tag_aws_iam_policy" {
  name   = "tag_aws_iam_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.tag_iam_access_policy_document.json
}

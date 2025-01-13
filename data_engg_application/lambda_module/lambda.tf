# Copy the lambda layer zip file to S3 bucket
resource "aws_s3_object" "aws_sdk_pandas_lambda_layer_zip" {
  bucket = element([for bucket in aws_s3_bucket.data_lake_bucket : bucket.id if bucket.tags["name"] == "lambda-layer"], 0)
  key    = "lambda-layers/awswrangler-layer-3.11.0/lambdalayer.zip"
  source = "${path.module}/libs/awswrangler-layer-3.11.0-py3.12.zip"
  etag   = filemd5("${path.module}/libs/awswrangler-layer-3.11.0-py3.12.zip")
}

# Create lambda layer from s3 object
resource "aws_lambda_layer_version" "aws_sdk_pandas_lambda_layer" {
  s3_bucket    = element([for bucket in aws_s3_bucket.data_lake_bucket : bucket.id if bucket.tags["name"] == "lambda-layer"], 0)
  s3_key       = aws_s3_object.aws_sdk_pandas_lambda_layer_zip.key
  layer_name   = "aws-sdk-pandas-layer-3-22-0"
  skip_destroy = false
  depends_on   = [aws_s3_object.aws_sdk_pandas_lambda_layer_zip]
}

# Create lambda package zip file
data "archive_file" "lambda_package" {
  type        = "zip"
  output_path = "${path.module}/libs/lambda.zip"
  source_file  = "${path.module}/lambda"
}
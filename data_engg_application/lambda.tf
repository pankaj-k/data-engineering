# Copy the lambda layer zip file to S3 bucket
resource "aws_s3_object" "aws_sdk_pandas_lambda_layer_zip" {
  bucket = element([for bucket in aws_s3_bucket.data_lake_buckets : bucket.id if bucket.tags["Name"] == "lambda-layer"], 0)
  # key    = "lambda-layers/awswrangler-layer-3.11.0/lambdalayer.zip"
  # source = "${path.module}/lambda_libs/awswrangler-layer-3.11.0-py3.12.zip"
  # etag   = filemd5("${path.module}/lambda_libs/awswrangler-layer-3.11.0-py3.12.zip")
  key    = "lambda-layers/awswrangler-layer-2.19.0/lambdalayer.zip"
  source = "${path.module}/lambda_libs/awswrangler-layer-2.19.0-py3.9.zip"
  etag   = filemd5("${path.module}/lambda_libs/awswrangler-layer-2.19.0-py3.9.zip")
}

# Create lambda layer from s3 object
resource "aws_lambda_layer_version" "aws_sdk_pandas_lambda_layer" {
  s3_bucket = element([for bucket in aws_s3_bucket.data_lake_buckets : bucket.id if bucket.tags["Name"] == "lambda-layer"], 0)
  s3_key    = aws_s3_object.aws_sdk_pandas_lambda_layer_zip.key
  #layer_name   = "aws-sdk-pandas-layer-3-11-0"
  layer_name   = "aws-sdk-pandas-layer-2-19-0"
  skip_destroy = false
  depends_on   = [aws_s3_object.aws_sdk_pandas_lambda_layer_zip]
}

# Create lambda package zip file
data "archive_file" "python_lambda_package" {
  type        = "zip"
  output_path = "csv_to_parquet.zip"
  source_file = "${path.module}/lambda_code/csv_to_parquet.py"
}

resource "aws_lambda_function" "csv_to_parquet_function" {
  function_name    = "csv_to_parquet_function"
  filename         = "csv_to_parquet.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  layers           = [aws_lambda_layer_version.aws_sdk_pandas_lambda_layer.arn]
  role             = aws_iam_role.data_engg_role.arn
  runtime          = "python3.9"
  handler          = "csv_to_parquet.lambda_handler"
  timeout          = 60 # Seconds
}

# Configure a trigger for the lambda function. 
# S3 file upload (in S3 bucket tagged landing-zone) event triggers the lambda function.
resource "aws_lambda_permission" "allow_s3_bucket_notification" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_to_parquet_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = element([for bucket in aws_s3_bucket.data_lake_buckets : bucket.arn if bucket.tags["Name"] == "landing-zone"], 0)
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = element([for bucket in aws_s3_bucket.data_lake_buckets : bucket.id if bucket.tags["Name"] == "landing-zone"], 0)

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_to_parquet_function.arn
    events              = ["s3:ObjectCreated:*"] # All object creation events like Put, Post Copy, Multipart upload, and others.
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3_bucket_notification]
}

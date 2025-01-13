# Generate random string for unique bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# Create S3 bucket with random suffix
resource "aws_s3_bucket" "data_lake_bucket" {
  for_each      = var.bucket_map
  bucket        = "${each.value.name}-${random_id.bucket_suffix.hex}"
  force_destroy = each.value.force_destroy
  tags = {
    name = each.value.tag
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = var.bucket_map
  bucket   = aws_s3_bucket.data_lake_bucket[each.key].id
  versioning_configuration {
    status = each.value.versioned
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  for_each = var.bucket_map
  bucket   = aws_s3_bucket.data_lake_bucket[each.key].id
  rule {
    id     = "data_engg_s3_lifecycle_rule"
    status = each.value.lifecycle
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER_IR"
    }
    expiration {
      days = 365
    }
  }
}

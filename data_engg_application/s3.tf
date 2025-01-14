# Generate random string for unique bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# Create S3 bucket with random suffix
resource "aws_s3_bucket" "data_lake_buckets" {
  for_each      = var.bucket_map
  bucket        = "${each.value.name}-${random_id.bucket_suffix.hex}"
  force_destroy = each.value.force_destroy
  tags = {
    Name = each.value.tag
  }
}

# Here we need some information from var.bucket_map to find which buckets have versioning enabled. 
resource "aws_s3_bucket_versioning" "data_lake_buckets_versioning" {
  # Need to access the value of versioned from var.bucket_map
  for_each = var.bucket_map
  # We access the id in the data_lake_buckets. each.key is common between bucket_map and data_lake_buckets. 
  # One sample value of each.key is "bucket1"
  bucket = aws_s3_bucket.data_lake_buckets[each.key].id
  versioning_configuration {
    status = each.value.versioned
  }
}

# Always encrypt by default
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_created_encryption" {
  for_each = aws_s3_bucket.data_lake_buckets
  bucket   = each.value.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.data_engg_kms_key.key_id
      sse_algorithm     = "aws:kms"
    }
  }
}


# Block public access
resource "aws_s3_bucket_public_access_block" "data_lake_buckets_block_public_access" {
  for_each                = aws_s3_bucket.data_lake_buckets
  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  for_each = var.bucket_map
  bucket   = aws_s3_bucket.data_lake_buckets[each.key].id
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

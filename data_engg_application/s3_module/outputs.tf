# output "bucket_ids" {
#   description = "Map of bucket names to their IDs"
#   value = {
#     for k, v in aws_s3_bucket.data_lake_bucket : k => v.id
#   }
# }

# output "bucket_arns" {
#   description = "Map of bucket names to their ARNs"
#   value = {
#     for k, v in aws_s3_bucket.data_lake_bucket : k => v.arn
#   }
# }

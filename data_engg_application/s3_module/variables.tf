# variable "region" {
#   description = "AWS region"
#   type        = string
#   default     = "us-east-1"
# }

# variable "bucket_map" {
#   description = "Map of S3 bucket configurations"
#   type = map(object({
#     name          = string
#     tag           = string
#     versioned     = string
#     lifecycle     = string
#     force_destroy = bool
#   }))
#   default = {
#     "bucket1" = {
#       name          = "dataeng-landing-zone"
#       tag           = "landing-zone"
#       versioned     = "Disabled"
#       lifecycle     = "Disabled"
#       force_destroy = true
#     }
#     "bucket2" = {
#       name          = "dataeng-clean-zone"
#       tag           = "clean-zone"
#       versioned     = "Disabled"
#       lifecycle     = "Disabled"
#       force_destroy = true
#     }
#     "bucket3" = {
#       name          = "dataeng-curated-zone"
#       tag           = "curated-zone"
#       versioned     = "Disabled"
#       lifecycle     = "Disabled"
#       force_destroy = true
#     }
#   }
# }

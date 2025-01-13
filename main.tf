provider "aws" {
  region = var.region
}

# Terraform state in S3 bucket. bucket variable needs a hard coded pre-existing bucket name. Terraform 
# cannot create a bucket to store state. I created it manually. 
terraform {
  backend "s3" {
    bucket = "store-tf-state-54fwty2045"
    key    = "data_engg_application/terraform.tfstate"
    region = "us-east-1" # This need not be same as the region where the resources are created.
  }
}

module "data_engg_app_s3_module" {
  source = "./data_engg_application/s3_module"
}

module "data_engg_app_lambda_module" {
  source = "./data_engg_application/lambda_module"
}


#   # Common variables
#   # environment = var.environment
#   region  = var.region
#   project = var.project_name

#   # Application specific variables
#   #instance_type   = var.instance_type
#   #instance_count  = var.instance_count

#   # Tags
#   tags = {
#     #Environment = var.environment
#     Project   = var.project_name
#     Terraform = "true"
#   }
#}

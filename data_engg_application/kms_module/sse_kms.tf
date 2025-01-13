# resource "aws_kms_key" "data_engg_s3_key" {
#   enable_key_rotation     = true
#   deletion_window_in_days = 7 # 7 days is minimum you can choose
#   tags = {
#     Name  = "data_engg_s3_key"
#     owner = "data_engg_team"
#   }
# }

# resource "aws_kms_alias" "alias" {
#   name          = "alias/data_engg_s3_key"
#   target_key_id = aws_kms_key.data_engg_s3_key.id
# }


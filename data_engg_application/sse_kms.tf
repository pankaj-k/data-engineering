resource "aws_kms_key" "data_engg_kms_key" {
  enable_key_rotation     = true
  deletion_window_in_days = 7   # Minimum number of days key stays in deactivated and scheduled for deletion. 7 days is minimum you can choose. 
  tags = {                      # This is a safe guard against accidental deletion.
    Name  = "data_engg_kms_key" # The key is not used during this time.
    owner = "data_engg_team"
  }
}

resource "aws_kms_alias" "alias" {
  name          = "alias/data_engg_kms_key" # Mandatory to have alias/ in the name.
  target_key_id = aws_kms_key.data_engg_kms_key.id
}


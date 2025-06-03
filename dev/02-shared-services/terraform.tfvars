secure_buckets = {
  important_info = {
    bucket_name = "edion-net-dev-important-info"
    region = "ap-northeast-1"
    object_lock_enabled = false
    server_side_encryption = {
      algorithm = "AES256"
      bucket_key_enabled = true
    }
    versioning_enabled = true
  },
  img_upload = {
    bucket_name = "edion-net-dev-img-upload"
    region = "ap-northeast-1"
    object_lock_enabled = false
    server_side_encryption = {
      algorithm = "AES256"
      bucket_key_enabled = true
    }
    versioning_enabled = true
  }
}

dynamodb_config = {
  table_name   = "edion-net-app-sessions-dev-table"
  hash_key     = "sessionId"
  billing_mode = "PAY_PER_REQUEST"
}

log_groups = [
  {
    name              = "/edion-net-dev/codepipeline/app-codepipeline"
    retention_in_days = 365
    class             = "STANDARD"
  },
  {
    name              = "/edion-net-dev/codepipeline/app-mgt-codepipeline"
    retention_in_days = 365
    class             = "STANDARD"
  },
  {
    name              = "/edion-net-dev/app/container-app-logs"
    retention_in_days = 365
    class             = "STANDARD"
  },
  {
    name              = "/edion-net-dev/app-mgt/container-app-logs"
    retention_in_days = 365
    class             = "STANDARD"
  }
]
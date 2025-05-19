variable "secure_buckets" {
  description = "Map of secure S3 buckets with enhanced security configurations"
  type = map(object({
    bucket_name = string
    region = string
    object_lock_enabled = bool
    server_side_encryption = object({
      algorithm = string
      bucket_key_enabled = bool
    })
    versioning_enabled = bool
  }))
}

variable "artifact_buckets" {
  description = "Map of simple artifact S3 buckets for CodePipeline"
  type = map(object({
    bucket_name = string
  }))
}
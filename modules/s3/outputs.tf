output "secure_bucket_arns" {
  description = "ARNs of the created secure S3 buckets"
  value = {
    for k, bucket in aws_s3_bucket.secure_buckets : k => bucket.arn
  }
}

output "artifact_bucket_arns" {
  description = "ARNs of the created artifact S3 buckets"
  value = {
    for k, bucket in aws_s3_bucket.artifact_buckets : k => bucket.arn
  }
}

output "secure_bucket_ids" {
  description = "IDs of the created secure S3 buckets"
  value = {
    for k, bucket in aws_s3_bucket.secure_buckets : k => bucket.id
  }
}

output "artifact_bucket_ids" {
  description = "IDs of the created artifact S3 buckets"
  value = {
    for k, bucket in aws_s3_bucket.artifact_buckets : k => bucket.id
  }
}
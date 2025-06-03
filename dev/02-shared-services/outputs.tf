output "secure_bucket_arns" {
  description = "ARNs of the created secure S3 buckets"
  value = module.s3.secure_bucket_arns
}

# Create secure S3 buckets with enhanced security features
resource "aws_s3_bucket" "secure_buckets" {
  for_each = var.secure_buckets
  
  bucket = each.value.bucket_name
  
  # The region attribute is deprecated in newer Terraform AWS provider versions
  # If you need to specify a region, use provider aliases instead
  
  object_lock_enabled = each.value.object_lock_enabled
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "secure_buckets" {
  for_each = var.secure_buckets
  
  bucket = aws_s3_bucket.secure_buckets[each.key].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_buckets" {
  for_each = var.secure_buckets
  
  bucket = aws_s3_bucket.secure_buckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = each.value.server_side_encryption.algorithm
    }
    
    bucket_key_enabled = each.value.server_side_encryption.bucket_key_enabled
  }
}

# Configure versioning
resource "aws_s3_bucket_versioning" "secure_buckets" {
  for_each = var.secure_buckets
  
  bucket = aws_s3_bucket.secure_buckets[each.key].id
  
  versioning_configuration {
    status = each.value.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# Configure public access blocks
resource "aws_s3_bucket_public_access_block" "secure_buckets" {
  for_each = var.secure_buckets
  
  bucket = aws_s3_bucket.secure_buckets[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create simple artifact buckets for CodePipeline
resource "aws_s3_bucket" "artifact_buckets" {
  for_each = var.artifact_buckets
  
  bucket = each.value.bucket_name
}

# Add default public access block for artifact buckets as well for better security
resource "aws_s3_bucket_public_access_block" "artifact_buckets" {
  for_each = var.artifact_buckets
  
  bucket = aws_s3_bucket.artifact_buckets[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
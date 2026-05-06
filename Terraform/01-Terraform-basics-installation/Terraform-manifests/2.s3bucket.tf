# Resource Block: Random String
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Resource Block: AWS S3 Bucket
resource "aws_s3_bucket" "ramesh_demo_bucket" {
  bucket = "devopsbootcamp-${random_string.suffix.result}"

  tags = {
    Name         = "Ramesh Demo Bucket"
    Environment  = "Dev"
    Owner        = "ramesh.mahipathi"
    Project_Name = "DevOps Bootcamp"
  }
}

# Enable Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.ramesh_demo_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.ramesh_demo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

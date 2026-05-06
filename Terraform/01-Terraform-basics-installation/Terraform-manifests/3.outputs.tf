# Output Block
output "s3_bucket_name" {
  value = aws_s3_bucket.ramesh_demo_bucket.bucket
}

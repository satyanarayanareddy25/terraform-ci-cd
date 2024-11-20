output "s3_endpoint" {
  value = aws_s3_bucket.react_app_bucket.website_endpoint
}
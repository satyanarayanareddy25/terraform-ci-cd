
resource "aws_s3_bucket" "react_app_bucket" {
  bucket        = var.bucket_name
  force_destroy = true # Allows Terraform to delete non-empty buckets
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "react_app_policy" {
  bucket = aws_s3_bucket.react_app_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.react_app_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket              = aws_s3_bucket.react_app_bucket.bucket
  block_public_policy = false
}



resource "null_resource" "upload_folder_to_s3" {
  provisioner "local-exec" {
    # command = "aws s3 cp ./build s3://${aws_s3_bucket.react_app_bucket.bucket}/ --recursive"
    command = "aws s3 cp index.html s3://${aws_s3_bucket.react_app_bucket.bucket}/"
  }

  depends_on = [
    aws_s3_bucket.react_app_bucket
  ]
}


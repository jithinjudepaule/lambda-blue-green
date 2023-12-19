
resource "aws_s3_bucket" "backend_s3_bucket"{
    bucket="tf-backend-bucket-1988-new"
    lifecycle{
        prevent_destroy=false
    }
}
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.backend_s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend_s3_bucket" {
  bucket = aws_s3_bucket.backend_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "backend_s3_bucket" {
  bucket                  = aws_s3_bucket.backend_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "backend-terraform-lock" {
    name           = "terraform_state"
    billing_mode = "PAY_PER_REQUEST"
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table 1"
    }
}
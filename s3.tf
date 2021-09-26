resource "aws_s3_bucket" "s3bucket" {
  bucket = "aws-final-task-mokulov"
  acl = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
  }
}

resource "aws_vpc_endpoint" "s3-endpoint" {
  vpc_id = aws_vpc.vpc_two.id
  service_name = "com.amazonaws.us-east-1.s3"
}
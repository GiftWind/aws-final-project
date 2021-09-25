resource "aws_s3_bucket" "s3bucket" {
  bucket = "s3-bucket"
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

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.vpc_two.id
  service_name = "com.amazonaws.us-east-1.s3"

}

resource "aws_vpc_endpoint_route_table_association" "private-two-s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private_two_rt.id
}
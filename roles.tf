resource "aws_iam_role" "S3access" {
  name = "S3access"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" = "sts:AssumeRole"
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
        }
      ]
  })
  inline_policy {
    name = "s3accesstoyum"
    policy = jsonencode({
      "Statement" : [
        {
          "Action" : [
            "s3:GetObject"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::amazonlinux.us-east-1.amazonaws.com/*",
            "arn:aws:s3:::amazonlinux-2-repos-us-east-1/*"
          ]
        }
      ]
    })
  }

  inline_policy {
    name = "s3access_to_my_bucket"
    policy = jsonencode({
      "Statement" : [
        {
          "Action" : [
            "s3:*"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "${aws_s3_bucket.s3bucket.arn}"
          ]
        }
      ]
    })
  }

  inline_policy {
    name = "s3fullaccess_to_my_bucket"
    policy = jsonencode({
      "Statement" : [
        {
          "Action" : [
            "s3:*"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "${aws_s3_bucket.s3bucket.arn}"
          ]
        }
      ]
    })
  }
    inline_policy {
    name = "s3readonlyaccess_to_my_buckets"
    policy = jsonencode({
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "*"
        }
    ]
    })
  }
    
}

resource "aws_iam_instance_profile" "Access_to_S3" {
  name = "Access_to_S3"
  role = aws_iam_role.S3access.name
}

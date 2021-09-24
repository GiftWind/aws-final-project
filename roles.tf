resource "aws_iam_role" "S3access" {
  name = "S3access"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      "Statement": [
        {
            "Effect": "Allow",
            "Action" = "sts:AssumeRole"
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
        }
      ]
    })
    inline_policy {
      name = "s3accesstoyum"
      policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::amazonlinux.us-east-1.amazonaws.com/*",
                "arn:aws:s3:::amazonlinux-2-repos-us-east-1/*"
            ]
        }
    ]
})
    }
}

resource "aws_iam_instance_profile" "Access_S3_to_yum" {
  name = "Access_S3_to_yum"
  role = aws_iam_role.S3access.name
}
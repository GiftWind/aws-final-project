resource "aws_cloudwatch_event_rule" "ec2_instance_state_change" {
  name        = "capture-ec2-state-change"
  description = "Capture EC2 instance start and shutdown"

  event_pattern = jsonencode({
    "source": [
      "aws.ec2"
    ],
    "detail-type": [
      "EC2 Instance State-change Notification"
    ],
    "detail": {
      "state": [
        "running",
        "shutting-down"
      ]
    }
  })
}

resource "aws_iam_role" "iam_role_for_lambda" {
  name = "iam_role_for_lambda"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
    }
    ]
  })

  inline_policy {
    name = "ec2-describe"
    policy = jsonencode({
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
            ],
            "Resource": "*"
        }
    ]
    })
  }
    inline_policy {
    name = "route53-edit"
    policy = jsonencode({
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListResourceRecordSets",
                "route53:ChangeResourceRecordSets",
                "route53:"
            ],
            "Resource": "${aws_route53_zone.private.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZonesByName",
            ],
            "Resource": "*"
        },
      ]
    })
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ChangeDNSRecord.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_instance_state_change.arn
}

resource "aws_cloudwatch_event_target" "ec2change-invokelambda" {
  rule = aws_cloudwatch_event_rule.ec2_instance_state_change.name
  target_id = "ChangeDNSRecord"
  arn = aws_lambda_function.ChangeDNSRecord.arn
}

data "archive_file" "lambda_archive" {
  type = "zip"
  source_dir  = "./ChangeDNSRecord" 
  output_path = "./ChangeDNSRecord.zip"
}

resource "aws_lambda_function" "ChangeDNSRecord" {
  filename = data.archive_file.lambda_archive.output_path
  function_name = "ChangeDNSRecord"
  role = aws_iam_role.iam_role_for_lambda.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"
}
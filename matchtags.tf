resource "aws_cloudwatch_event_rule" "daily_invocation" {
  name        = "invoke-match-tags-daily"
  description = "Invoke lambda to match the tags daily"
  schedule_expression = "rate(24 hours)"
}

resource "aws_cloudwatch_event_target" "daily-invokelambda" {
  rule = aws_cloudwatch_event_rule.daily_invocation.name
  target_id = "MatchTheTags"
  arn = aws_lambda_function.MatchTheTags.arn
}

resource "aws_iam_role" "iam_role_for_lambda_matchtags" {
  name = "iam_role_for_lambda_matchtags"
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
                "ec2:DescribeVolumes",
                "ec2:CreateTags"
            ],
            "Resource": "*"
        }
    ]
    })
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_daily" {
  statement_id  = "AllowDailyInvocationFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.MatchTheTags.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_invocation.arn
}



data "archive_file" "lambda_archive_matchtags" {
  type = "zip"
  source_dir  = "./MatchTheTags" 
  output_path = "./MatchTheTags.zip"
}

resource "aws_lambda_function" "MatchTheTags" {
  filename = data.archive_file.lambda_archive_matchtags.output_path
  function_name = "MatchTheTags"
  role = aws_iam_role.iam_role_for_lambda_matchtags.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"
}
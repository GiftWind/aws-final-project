# resource "aws_iam_role" "AllowBastionToChangeEBS" {
#   name = "AllowBastionToChangeEBS"
#   assume_role_policy = jsonencode(
#   {
#       Version = "2012-10-17"
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Action" = "sts:AssumeRole"
#           "Principal" : {
#             "Service" : "ec2.amazonaws.com"
#           },
#         }
#       ]
#   })

#   inline_policy {
#     name = "AccessToEBS"
#     policy = jsonencode({
#       "Statement" : [
#         {
#           "Action" : "ec2:ModifyVolume",
#           "Effect" : "Allow",
#           "Resource" : "${aws_instance.bastion.root_block_device[0]}",
#         }
#       ]
#     })
#   }
# }

# resource "aws_iam_instance_profile" "Access_to_EBS" {
#   name = "Access_to_S3"
#   role = aws_iam_role.AllowBastionToChangeEBS.name
# }
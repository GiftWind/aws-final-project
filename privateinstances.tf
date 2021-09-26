resource "aws_instance" "private_instance_vpc_two" {
  ami                    = data.aws_ssm_parameter.linux_latest_ami.value
  instance_type          = "t2.micro"
  key_name               = "aws_final_project_keys"
  subnet_id              = aws_subnet.vpc_two_private_subnet.id
  vpc_security_group_ids = [aws_security_group.general-sg-vpc-two.id, aws_security_group.private-sg-two.id]
  iam_instance_profile   = aws_iam_instance_profile.Access_to_S3.name
  user_data              = templatefile("user_data_private.sh", {})
  tags = {
    Name    = "Private Instance VPC Two"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
    Environment = "Testing"
  }
}

resource "aws_instance" "private_instance_vpc_two_2" {
  ami                    = data.aws_ssm_parameter.linux_latest_ami.value
  instance_type          = "t2.micro"
  key_name               = "aws_final_project_keys"
  subnet_id              = aws_subnet.vpc_two_private_subnet_two.id
  vpc_security_group_ids = [aws_security_group.general-sg-vpc-two.id, aws_security_group.private-sg-two.id]
  iam_instance_profile   = aws_iam_instance_profile.Access_to_S3.name
  user_data              = templatefile("user_data_private.sh", {})
  tags = {
    Name    = "Private Instance VPC Two"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
    Environment = "Testing"
  }
}
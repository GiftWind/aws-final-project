data "aws_ssm_parameter" "linux_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "bastion" {
  ami = data.aws_ssm_parameter.linux_latest_ami.value
  instance_type = "t2.micro"
  key_name = "aws_final_project_keys"
  subnet_id = aws_subnet.vpc_one_public_subnet.id
  vpc_security_group_ids = [aws_security_group.general-sg.id, aws_security_group.bastion-sg.id]
  #iam_instance_profile   = aws_iam_instance_profile.Access_to_EBS.name

  tags = {
    Name    = "Bastion Host"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}



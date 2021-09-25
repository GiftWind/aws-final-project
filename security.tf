resource "aws_security_group" "general-sg" {
  description = "HTTP egress to anywhere"
  vpc_id      = aws_vpc.vpc_one.id
  tags = {
    Name    = "General security group"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_security_group" "general-sg-vpc-two" {
  description = "HTTP egress to anywhere"
  vpc_id      = aws_vpc.vpc_two.id
  tags = {
    Name    = "General security group VPC One"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_security_group" "bastion-sg" {
  vpc_id = aws_vpc.vpc_one.id
  tags = {
    Name    = "Bastion Host SG"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_security_group" "private-sg" {
  vpc_id = aws_vpc.vpc_one.id
  tags = {
    Name    = "Private subnet SG"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_security_group" "private-sg-two" {
  vpc_id = aws_vpc.vpc_two.id
  tags = {
    Name    = "Private subnet Two SG"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_security_group_rule" "out-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.general-sg.id
}

resource "aws_security_group_rule" "out-ssh-bastion" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion-sg.id
  source_security_group_id = aws_security_group.private-sg.id
}

resource "aws_security_group_rule" "out-ssh-bastion-two" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion-sg.id
  source_security_group_id = aws_security_group.private-sg-two.id
}

resource "aws_security_group_rule" "out-all-private" {
  type              = "egress"
  description       = "Allow all traffic egress from private network"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private-sg.id
}

resource "aws_security_group_rule" "out-all-private-two" {
  type              = "egress"
  description       = "Allow all traffic egress from private network two"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private-sg-two.id
}

resource "aws_security_group_rule" "in-ssh-bastion-from-anywhere" {
  type              = "ingress"
  description       = "Allow SSH to bastion from anywhere"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "in-ssh-private-from-bastion" {
  type                     = "ingress"
  description              = "Allow SSH to private from bastion sg"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private-sg.id
  source_security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "in-http-private-from-bastion" {
  type                     = "ingress"
  description              = "Allow HHTP to private from bastion sg"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private-sg.id
  source_security_group_id = aws_security_group.general-sg.id
}

resource "aws_security_group_rule" "in-http-private-from-bastion-two" {
  type                     = "ingress"
  description              = "Allow HHTP to private from bastion sg"
  from_port                = 8888
  to_port                  = 8888
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private-sg-two.id
  source_security_group_id = aws_security_group.general-sg.id
}


resource "aws_security_group_rule" "in-http-private-from-lb-two" {
  type                     = "ingress"
  description              = "Allow HTTP to private from Load Balancer sg"
  from_port                = 8888
  to_port                  = 8888
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private-sg-two.id
  source_security_group_id = aws_security_group.alb-sg.id
}

resource "aws_security_group_rule" "in-ssh-private-two-from-bastion" {
  type                     = "ingress"
  description              = "Allow SSH to private two from bastion sg"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private-sg-two.id
  source_security_group_id = aws_security_group.bastion-sg.id
}
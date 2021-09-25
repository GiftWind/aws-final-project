resource "aws_vpc" "vpc_one" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name    = "VPC One"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_vpc" "vpc_two" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name    = "VPC Two"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_subnet" "vpc_one_public_subnet" {
  vpc_id                  = aws_vpc.vpc_one.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  cidr_block              = "10.1.1.0/24"
  tags = {
    Name    = "VPC One Public Subnet"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_subnet" "vpc_one_private_subnet" {
  vpc_id                  = aws_vpc.vpc_one.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  cidr_block              = "10.1.2.0/24"
  tags = {
    Name    = "VPC One Private Subnet"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}



resource "aws_subnet" "vpc_two_public_subnet" {
  vpc_id                  = aws_vpc.vpc_two.id
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  cidr_block              = "10.2.1.0/24"
  tags = {
    Name    = "VPC Two Public Subnet"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_subnet" "vpc_two_public_subnet_two" {
  vpc_id                  = aws_vpc.vpc_two.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  cidr_block              = "10.2.4.0/24"
  tags = {
    Name    = "VPC Two Public Subnet Two"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_subnet" "vpc_two_private_subnet" {
  vpc_id                  = aws_vpc.vpc_two.id
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  cidr_block              = "10.2.2.0/24"
  tags = {
    Name    = "VPC Two Private Subnet"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_subnet" "vpc_two_private_subnet_two" {
  vpc_id                  = aws_vpc.vpc_two.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  cidr_block              = "10.2.3.0/24"
  tags = {
    Name    = "VPC Two Private Subnet Two"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_internet_gateway" "igw_one" {
  vpc_id = aws_vpc.vpc_one.id
  tags = {
    Name    = "VPC One IGW"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_route_table" "public_rt_one" {
  vpc_id = aws_vpc.vpc_one.id
  tags = {
    Name    = "VPC One Public Subnet RT"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_route" "public_one_to_internet" {
  route_table_id         = aws_route_table.public_rt_one.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_one.id
}

resource "aws_route" "public_one_to_vpc_two" {
  route_table_id            = aws_route_table.public_rt_one.id
  destination_cidr_block    = "10.2.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}

resource "aws_route_table_association" "public_one_rt_assoc" {
  subnet_id      = aws_subnet.vpc_one_public_subnet.id
  route_table_id = aws_route_table.public_rt_one.id
}

resource "aws_internet_gateway" "igw_two" {
  vpc_id = aws_vpc.vpc_two.id
  tags = {
    Name    = "VPC Two IGW"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_route_table" "public_rt_two" {
  vpc_id = aws_vpc.vpc_two.id
  tags = {
    Name    = "VPC Two Public Subnet RT"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_route" "public_two_to_internet" {
  route_table_id         = aws_route_table.public_rt_two.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_two.id
}

resource "aws_route" "private_two_to_vpc_one" {
  route_table_id            = aws_route_table.private_two_rt.id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}

resource "aws_route_table_association" "public_two_rt_assoc" {
  subnet_id      = aws_subnet.vpc_two_public_subnet.id
  route_table_id = aws_route_table.public_rt_two.id
}
resource "aws_route_table_association" "public_two_rt_two_assoc" {
  subnet_id      = aws_subnet.vpc_two_public_subnet_two.id
  route_table_id = aws_route_table.public_rt_two.id
}

resource "aws_route_table_association" "private_two_rt_assoc" {
  subnet_id      = aws_subnet.vpc_two_private_subnet.id
  route_table_id = aws_route_table.private_two_rt.id
}

resource "aws_route_table_association" "private_two_rt_assoc_2" {
  subnet_id      = aws_subnet.vpc_two_private_subnet_two.id
  route_table_id = aws_route_table.private_two_rt.id
}

resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id = aws_vpc.vpc_two.id
  vpc_id      = aws_vpc.vpc_one.id
  auto_accept = true
}

resource "aws_route_table" "private_one_rt" {
  vpc_id = aws_vpc.vpc_one.id
  tags = {
    Name    = "Private One RT"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_route_table" "private_two_rt" {
  vpc_id = aws_vpc.vpc_two.id
  tags = {
    Name    = "Private One RT"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_route_table_association" "private_one_rt_assoc" {
  subnet_id      = aws_subnet.vpc_one_private_subnet.id
  route_table_id = aws_route_table.private_one_rt.id
}

resource "aws_vpc_endpoint" "s3-one" {
  vpc_id       = aws_vpc.vpc_one.id
  service_name = "com.amazonaws.us-east-1.s3"
  tags = {
    Name    = "S3 Endpoint One"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_vpc_endpoint" "s3-two" {
  vpc_id       = aws_vpc.vpc_two.id
  service_name = "com.amazonaws.us-east-1.s3"
  tags = {
    Name    = "S3 Endpoint Two"
    Owner   = "Mark Okulov"
    Project = "AWS Final Task"
  }
}

resource "aws_vpc_endpoint_route_table_association" "private_one_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3-one.id
  route_table_id  = aws_route_table.private_one_rt.id
}

resource "aws_vpc_endpoint_route_table_association" "private_two_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3-two.id
  route_table_id  = aws_route_table.private_two_rt.id
}
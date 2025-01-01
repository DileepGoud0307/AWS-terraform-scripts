#AWS Provider Configuration
provider "aws" {
  region = "ap-south-1" # Change this to your desired AWS region
}

#VPC Configuration
resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default" 
  tags = {
    Name = "my_vpc"
  }
}

# Subnet Configuration
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.1.0/24" # Adjust as needed
  availability_zone       = "ap-south-1a"   # Change this to your desired availability zone
  tags = {
    Name = "public"
  }
}

# Subnet Configuration
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.3.0/24" # Adjust as needed
  availability_zone       = "ap-south-1a"   # Change this to your desired availability zone
  tags = {
    Name = "private"
  }
}

# Internet Gateway Configuration
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}

resource "aws_eip" "ip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "ngw"
  }
}

# Route Table Configuration
resource "aws_route_table" "rt_1" {
  vpc_id = aws_vpc.my_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "rt_1"
  }
}


# Route Table Configuration
resource "aws_route_table" "rt_2" {
  vpc_id = aws_vpc.my_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "rt_2"
  }
}

resource "aws_route_table_association" "as_1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt_1.id
}

resource "aws_route_table_association" "as_2" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt_2.id
}

resource "aws_security_group" "sg" {
  name        = "first-SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.my_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


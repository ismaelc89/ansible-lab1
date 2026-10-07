resource "aws_vpc" "ansible_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ansible_vpc"
  }
}

resource "aws_internet_gateway" "ansible_ig" {
  vpc_id = aws_vpc.ansible_vpc.id

  tags = {
    Name = "ansible_ig"
  }
}

resource "aws_subnet" "ansible_subnet" {
  vpc_id                  = aws_vpc.ansible_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ansible_public_subnet"
  }
}

resource "aws_route_table" "ansible_public_rt" {
  vpc_id = aws_vpc.ansible_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ansible_ig.id
  }

  tags = {
    Name = "ansible_rt"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.ansible_public_rt.id
  subnet_id      = aws_subnet.ansible_subnet.id
}

resource "aws_security_group" "public_ec2_sg" {
  name        = "web_ec2_sg"
  description = "SG for public ec2"
  vpc_id      = aws_vpc.ansible_vpc.id

  tags = {
    Name = "web_ec2_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.public_ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


resource "aws_instance" "ansible_instance" {
  ami                    = data.aws_ami.amazon_ami.id
  key_name               = "MyEC2KeyPair"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.ansible_subnet.id
  vpc_security_group_ids = [aws_security_group.public_ec2_sg.id]

  tags = {
    Name        = "Ansible_Instance"
    Environment = var.instance_env
  }
}


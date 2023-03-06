################ Public EC2 Security Group ##############
resource "aws_security_group" "public_sg"{
  name        = "public_sg"
  description = "Allow TLS inbound traffic for public instance"
  vpc_id = aws_vpc.terra_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
#   ingress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     # cidr_blocks      = [aws_security_group.private_sg.id]
#   }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "public_sg"
  }
  lifecycle {
    create_before_destroy = false
  }
}

################ Private EC2 Security Group ##############
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow TLS inbound traffic for public instance"
  vpc_id = aws_vpc.terra_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    # cidr_blocks      = [aws_security_group.public_sg.id]
  }
  # ingress {
  #   description      = "TLS from VPC"
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "TCP"
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # cidr_blocks      = [aws_security_group.public_sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "private_sg"
  }
  lifecycle {
    create_before_destroy = false
  }
}

################ ALB Security Group ##############
resource "aws_security_group" "alb_sg"{
  name        = "alb_sg"
  description = "Allow TLS inbound traffic for public instance"
  vpc_id = aws_vpc.terra_vpc.id
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "alb_sg"
  }
  lifecycle {
    create_before_destroy = false
  }
}
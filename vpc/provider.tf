############## Provider ###########
provider "aws" {
  region = "us-east-1"
}

############## VPC #############
resource "aws_vpc" "terra_vpc" {
  cidr_block       = "172.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terra_vpc"
  }
}

############## Public SubNet ##############
resource "aws_subnet" "public-sn-1" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "172.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-sn-1"
  }
}

resource "aws_subnet" "public-sn-2" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "172.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-sn-2"
  }
}

resource "aws_subnet" "public-sn-3" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "172.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "public-sn-3"
  }
}

############## Private SubNet ##############
resource "aws_subnet" "private-sn-1" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "172.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-sn-1"
  }
}

resource "aws_subnet" "private-sn-2" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "172.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-sn-2"
  }
}

resource "aws_subnet" "private-sn-3" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "172.0.5.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private-sn-3"
  }
}

############## IGW ############
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "igw"
  }
}

############# EIP ###########
resource "aws_eip" "EIP" {
    vpc = true
    tags = {
        Name = "EIP"
    }
}

############## NAT ############
resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.EIP.id
    subnet_id = aws_subnet.public-sn-1.id

    tags = {
        Name = "NAT-GW"
    }
}
############# Public RouteTable ###########
resource "aws_route_table" "public-routetable" {
  vpc_id = aws_vpc.terra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-routetable"
  }
}

############ SubNet Association Public-RT ##############
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public-sn-1.id
  route_table_id = aws_route_table.public-routetable.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public-sn-2.id
  route_table_id = aws_route_table.public-routetable.id
}
resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public-sn-3.id
  route_table_id = aws_route_table.public-routetable.id
}

############# Private RouteTable ###########
resource "aws_route_table" "private-routetable" {
  vpc_id = aws_vpc.terra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "private-routetable"
  }
}

############ SubNet Association Private-RT ##############
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private-sn-1.id
  route_table_id = aws_route_table.private-routetable.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private-sn-2.id
  route_table_id = aws_route_table.private-routetable.id
}
resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private-sn-3.id
  route_table_id = aws_route_table.private-routetable.id
}

################ Public Security Group ##############
resource "aws_security_group" "public_sg"{
  name        = "public_sg"
  description = "Allow TLS inbound traffic for public instance"
  vpc_id = aws_vpc.terra_vpc.id

  # ingress {
  #   description      = "TLS from VPC"
  #   from_port        = 22
  #   to_port          = 22
  #   protocol         = "SSH"
  #   cidr_blocks      = ["0.0.0.0/0"]
  # }
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
    # cidr_blocks      = [aws_security_group.private_sg.id]
  }
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

################ Private Security Group ##############
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow TLS inbound traffic for public instance"
  vpc_id = aws_vpc.terra_vpc.id

  # ingress {
  #   description      = "TLS from VPC"
  #   from_port        = 22
  #   to_port          = 22
  #   protocol         = "SSH"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   # cidr_blocks      = [aws_security_group.public_sg.id]
  # }
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

############## Public Network Interface ############
# resource "aws_network_interface" "pub_ni" {
#   subnet_id   = aws_subnet.public-sn-1.id
#   private_ips = ["172.0.0.0/24"]

#   tags = {
#     Name = "pub_ni"
#   }
# }

############## Private Network Interface ############
# resource "aws_network_interface" "pri_ni" {
#   subnet_id   = aws_subnet.private-sn-1.id
#   private_ips = ["172.0.3.0/24"]

#   tags = {
#     Name = "pri_ni"
#   }
# }

################ Public Instance ################
# resource "aws_instance" "foo" {
#   ami           = "ami-005e54dee72cc1d00" # us-west-2
#   instance_type = "t2.micro"

#   network_interface {
#     network_interface_id = aws_network_interface.foo.id
#     device_index         = 0
#   }

#   credit_specification {
#     cpu_credits = "unlimited"
#   }
# }
resource "aws_instance" "pub_ec2" {
  ami = "ami-09cd747c78a9add63"
  instance_type = "t3a.micro"
  subnet_id = aws_subnet.public-sn-1.id
  associate_public_ip_address = true
  key_name = "Jinkins"


  vpc_security_group_ids = [
    aws_security_group.public_sg.id
  ]
  root_block_device {
    delete_on_termination = true
    # iops = 150
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {
    Name ="pub_ec2"
    Environment = "PUB_DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  # depends_on = [ aws_security_group.public_sg ]
}


output "ec2instance" {
  value = aws_instance.pub_ec2.public_ip
}

####################### Private Instance ####################
resource "aws_instance" "pri_ec2" {
  ami = "ami-09cd747c78a9add63"
  instance_type = "t3a.micro"
  subnet_id = aws_subnet.private-sn-1.id
  key_name = "Jinkins"


  vpc_security_group_ids = [
    aws_security_group.private_sg.id
  ]
  root_block_device {
    delete_on_termination = true
    # iops = 150
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {
    Name ="pri_ec2"
    Environment = "PUB_DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  # depends_on = [ aws_security_group.private_sg ]
}

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


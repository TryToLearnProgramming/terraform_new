
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

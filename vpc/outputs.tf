output "public_ec2_instance" {
  value = aws_instance.pub_ec2.public_ip
}

output "alb_arn" {
  value = aws_lb.alb.arn
}
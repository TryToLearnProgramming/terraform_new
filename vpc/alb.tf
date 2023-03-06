############# ALB Create ############
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public-sn-1.id,aws_subnet.public-sn-2.id,aws_subnet.public-sn-3.id]

  enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Name = "alb"
    Environment = "dev"
  }
}
############## ALB TargetGroup ##############
resource "aws_lb_target_group" "alb-tg" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terra_vpc.id

  health_check {
      healthy_threshold   = var.health_check["healthy_threshold"]
      interval            = var.health_check["interval"]
      unhealthy_threshold = var.health_check["unhealthy_threshold"]
      timeout             = var.health_check["timeout"]
      path                = var.health_check["path"]
      port                = var.health_check["port"]
  }

  tags = {
    Name = "alb-tg"
  }
}

########### ALB_TG EC2 Attachment ###########
resource "aws_lb_target_group_attachment" "alb-tg-atach" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_instance.pri_ec2.id
  port             = 80
}

########## ALB Listener Add##########
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}
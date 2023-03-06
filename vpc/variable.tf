# variable "lb_tg_arn" {
#   type    = string
#   default = ""
# }

# variable "lb_tg_name" {
#   type    = string
#   default = ""
# }

# data "aws_lb_target_group" "test" {
#   arn  = var.lb_tg_arn
#   name = var.lb_tg_name
# }

# Declare the ALB names required for creation
# Here, we are creating two ALBs "test" and "test1"
# variable "alb_names" {
#    type = map
#    default = { for alb_names in ["test", "test1" ] : alb_names =>     alb_names }
# }
# Map used for providing details for health-check
# You can use the values based on your requirements
variable "health_check" {
   type = map(string)
   default = {
      "timeout"  = "10"
      "interval" = "20"
      "path"     = "/"
      "port"     = "80"
      "unhealthy_threshold" = "2"
      "healthy_threshold" = "3"
    }
}
# Mention the security names to be used
# Make sure the SG provided is having access to HTTP and HTTPs
# variable "security_grp" {
#     type = list
#     default = ["sg-053d8XXXXX01a"]}# Mention the subnets
# variable "subnets" {
#     type = list
#     default = ["subnet-02XXX69","subnet-66XXXXa","subnet-57XXXd"]}
##
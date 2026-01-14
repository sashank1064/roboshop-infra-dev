resource "aws_ssm_parameter" "backend_alb_sg_id" {
  name  = "/${var.project}/${var.environment}/backend_alb_llistener_arn"
  type  = "String"
  value = aws_lb_listener.backend_alb.arn
}
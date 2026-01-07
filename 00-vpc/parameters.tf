resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.Project}/${var.environment}/vpc-id"
  type  = "String"
  value = module.vpc.vpc_id
}
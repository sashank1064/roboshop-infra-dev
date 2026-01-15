data "aws_ami" "joindevops" {

  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }


  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}




data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc-id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public-subnet-ids"
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${var.project}/${var.environment}/frontend-alb-sg-id" 
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.project}/${var.environment}/acm-certificate-arn"
}
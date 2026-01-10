variable "project" {
  description = "Project name for tagging"
  type        = string
  default = "roboshop"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default = "dev"
}

variable "frontend_sg_name" {
  description = "Name of the frontend security group"
  type        = string
  default = "frontend"
}

variable "frontend_sg_description" {
  description = "Description of the frontend security group"
  type        = string
  default = "Security group for frontend instances"
}
/* 
variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
  default = "value"
} */


variable "bastion_sg_name" {
  description = "Name of the bastion security group"
  type        = string
  default = "bastion"
}

variable "bastion_sg_description" {
  description = "Description of the bastion security group"
  type        = string
  default = "Security group for bastion instances"
}

variable "mongodb_ports_vpn" {
  description = "Ports for MongoDB access from VPN"
  type        = list(number)
  default     = [22, 27017]
}

variable "redis_ports_vpn" {
  description = "Ports for Redis access from VPN"
  type        = list(number)
  default     = [22, 6379]
}

variable "mysql_ports_vpn" {
  description = "Ports for MySQL access from VPN"
  type        = list(number)
  default     = [22, 3306]
}

variable "rabbitmq_ports_vpn" {
  description = "Ports for RabbitMQ access from VPN"
  type        = list(number)
  default     = [22, 5672]
}
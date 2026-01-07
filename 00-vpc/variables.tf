variable "Project" {
  description = "The name of the project"
  type        = string
  default     = "roboshop"

}

variable "environment" {
  description = "The environment name"
  type        = string
  default     = "dev"

}

variable "public_subnet_cidrs" {
  description = "The CIDR block for the public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "database_subnet_cidrs" {
  description = "The CIDR block for the database subnet"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

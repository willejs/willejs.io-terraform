/* Set all variables here, no exceptions */

variable "vpc_subnet" {
  default     = "10.0.0.0/16"
  description = "Set the CIDR of the VPC subnet"
}

variable "private_subnets" {
  type        = "list"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Private subnets for non public NAT routed resources"
}

variable "public_subnets" {
  type        = "list"
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
  description = "Public subnets for public routed resources"
}

variable "availability_zones" {
  type        = "list"
  default     = ["eu-west-1a", "eu-west-1b"]
  description = "Availability zones to place the private/public subnets in"
}

variable "aws_ssh_key_file" {
  default     = "default"
  description = "ssh public key file"
}

variable "project_name" {
  default     = "willejsio"
  description = "Project name is used when naming of resources for uniqueness"
}

variable "environment" {
  default     = "prod"
  description = "application environment"
}

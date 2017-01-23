/* Set all variables here, no exceptions */

variable "vpc_subnet" {
  default = "10.0.0.0/16"
  description = "Set the CIDR of the VPC subnet"
}

variable "private_subnets" {
  default = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
  description = "Private subnets for non public NAT routed resources"
}

variable "public_subnets" {
  default = "10.0.4.0/24,10.0.5.0/24,10.0.6.0/24"
  description = "Public subnets for public routed resources"
}

variable "project_name" {
  default = "willejsio"
  descriprion = "Project name is used when naming of resources for uniqueness"
}

variable "availability_zones" {
  default = "eu-west-1a,eu-west-1b,eu-west-1c"
  description = "Availability zones to place the private/public subnets in"
}

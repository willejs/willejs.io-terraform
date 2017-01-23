variable "vpc_subnet" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
}

variable "public_subnets" {
  default = "10.0.4.0/24,10.0.5.0/24,10.0.6.0/24"
}

variable "project_name" {
  default = "willejsio"
}

variable "availability_zones" {
  default = "eu-west-1a,eu-west-1b,eu-west-1c"
}

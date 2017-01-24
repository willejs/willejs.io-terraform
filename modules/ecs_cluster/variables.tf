variable "instance_type" {
  default = "t2.nano"
  description = "Tiny instances for docker containers"
}

variable "ec2_key_pair" {
  description = "ec2 keypair to use with the ECS instances"
}

variable "instance_id" {
  description = "the unique instance id of the module"
}

variable "project_name" {
  description = "name of the project"
}

variable "environment" {
  description = "environment of the project"
}

variable "vpc_subnet" {
  description = "VPC subnet the instances should sit in"
}

variable "vpc_id" {
  description = "VPC id"
}
 // TODO: this should be a list
variable "private_subnets" {
  description = "private subnets for ECS cluster nodes"
}

variable "public_subnets" {
  description = "public subnets for AWS ALB"
}

variable "ecs_image_id" {
  // should look this up somehow.
  default = "ami-e3fbd290"
  description = "ecs optimised ec2 ami"
}

variable "willejs_io_version" {
  description = "set the docker tag of the image to be deployed"
  default = "latest"
}
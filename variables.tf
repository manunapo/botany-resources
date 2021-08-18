variable "profile" {
  default = "personal"
}

variable "region" {
  default = "us-east-1"
}

variable "availability_zone" {
     default = "us-east-1a"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_count" {
  default = "1"
}

variable "key_name" {
    default = "botany-ssh-key"
}

variable "ami" {
  default = "ami-9391e585"
}

variable "db_Administrator_password" {}

variable "vpc_CIDR_block" {
    default = "10.0.0.0/16"
}

variable "subnet_CIDR_block" {
    default = "10.0.1.0/24"
}

variable "destination_CIDR_block" {
    default = "0.0.0.0/0"
}

#Be aware here! restringe more the access
variable "ingress_CIDR_block" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egress_CIDR_block" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "map_public_IP" {
    default = true
}
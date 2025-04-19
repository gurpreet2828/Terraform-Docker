#-----compute/variables.tf-----
#===============================
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_key_public" {
  type    = string
  default = "/root/.ssh/docker.pub"
}

variable "ssh_key_private" {
  type    = string
  default = "/root/.ssh/docker"
}

variable "subnet_ips" {}

variable "security_group" {}

variable "subnets" {}

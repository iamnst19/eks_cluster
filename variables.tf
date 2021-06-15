#
# Variables Configuration

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "subnet" {
  description = "list of subnets"
  default = []
}
variable "cluster-name" {
  description = "eks cluster name"
  default     = "demo"
  type        = string
}


variable "num-workers" {
  description = "Number of eks worker instances to deploy."
  default = "2"
  type    = string
}

variable "max-workers" {
  description = "Max number of eks worker instances that can be scaled."
  default = "5"
  type    = string
}

variable "inst-type" {
  description = "EKS worker instance type."
  default     = "m5.large"
  type        = string
}

variable "inst_disk_size" {
  description = "EKS worker instance disk size in Gb."
  default     = "60"
  type        = string
}

variable "k8s_version" {
  description = "Kubernetes version."
  default     = "1.19"
  type        = string
}
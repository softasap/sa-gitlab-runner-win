variable "keyname" {
  default = "voronenko_info"
}

variable "support_network" {
  default = "0.0.0.0/32"
}

variable "AWS_PROFILE" {
  type        = string
  description = "AWS profile"
}

variable "AWS_REGION" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}


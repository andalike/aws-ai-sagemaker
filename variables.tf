variable "profile" {
  description = "Profile of the user to run AWS CLI"
  default     = "iamaws2006"
  type        = string
}

variable "region" {
  description = "Region Where to run the sagemaker"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR of VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_tenancy" {
  description = "Tenancy of VPC"
  type        = string
  default     = "default"
}

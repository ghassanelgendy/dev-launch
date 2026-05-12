variable "region" {
  description = "AWS region"
  type        = "string"
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = "string"
  default     = "devlaunch-eks"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = "string"
  default     = "devlaunch-vpc"
}

variable "app_name" {
  description = "Name of the application for ECR"
  type        = "string"
  default     = "payments-api"
}

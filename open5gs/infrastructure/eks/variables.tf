variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "cntf-open5gs-cluster"
}

variable "vpc_id" {
  type    = string
  default = "vpc-05a8ec54222fa40e2"
}
# variable "vpc_id" {
#   type    = string
#   default = "vpc-079d1a939306e311f"
# }

variable "private_subnets" {
  type    = list(any)
  default = ["subnet-009976b4a3c08ec9f", "subnet-0da7894199f5c3731"]
}
# variable "private_subnets" {
#   type    = list(any)
#   default = ["subnet-0ebdfa23a1ac3f9a6", "subnet-09d5db76f3f1e66d5"]
# }

variable "desired_size" {
  type    = string
  default = "5"
}

variable "min_size" {
  type    = string
  default = "4"
}

variable "max_size" {
  type    = string
  default = "6"
}

variable "image_id" {
  type    = string
  default = "ami-00c39f71452c08778"
}

variable "instance_type" {
  type    = string
  default = "t2.large"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.24"
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}

variable "node_instance_type" {
  type        = string
  default     = "t2.medium"
  description = "Desired Kubernetes node instance type. If you do not specify a value, t2.medium is used"
}

variable "enable_irsa" {
  type        = bool
  default     = true
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
}

variable "enable_ssm" {
  type        = bool
  default     = true
  description = "Determines whether to use AWS SSM"
}

# Per example here: https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/examples/fully-private-eks-cluster/main.tf
# When creating a new cluster, create it first as public and then change to private
variable "cluster_endpoint_public_access" {
  type        = bool
  default     = false
  description = "Determines whether to allow public access to the cluster"
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"

  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"

  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "coralogix_write_key" {
  sensitive   = true
  type        = string
  description = "the secret write keyto ship logs to coralogix via fluentd"
  default     = ""
}

variable "bucket_name_one" {
  default = "cntf-open5gs-coralogix-logs"
}

variable "bucket_name_two" {
  default = "cntf-open5gs-coralogix-metrics"
}

variable "bucket_name_three" {
  default = "cntf-open5gs-coralogix-test-results"
}

variable "aws_ecr_repository_name" {
  default = "cntf-ueransim-puppeteer"
}

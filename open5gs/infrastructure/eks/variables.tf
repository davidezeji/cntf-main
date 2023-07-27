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
  default = "vpc-0e97acae1f3e98180"
}

variable "subnets" {
  type    = list(any)
  default = ["subnet-01ca90ff571a722b5", "subnet-05bf6978b0e395268"]
}

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
  default = "cntf-open5gs-logs"
}

variable "bucket_name_two" {
  default = "cntf-open5gs-metrics"
}

variable "bucket_name_three" {
  default = "cntf-open5gs-test-results"
}

variable "bucket_name_four" {
  default = "cntf-tfstate"
}

variable "bucket_name_five" {
  default = "cntf-gitlab-ci-cache"
}

variable "aws_ecr_repository_name" {
  default = "cntf-ueransim-puppeteer"
}

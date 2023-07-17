module "eks" {
  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::935370813358:user/david.ezeji@dish.com"
      username = "david.ezeji@dish.com"
      groups   = ["system:masters"]
    },

    {
      userarn  = "arn:aws:iam::935370813358:user/pierce.alworth@dish.com"
      username = "pierce.alworth@dish.com"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::935370813358:role/AWSReservedSSO_AWSAdministratorAccess_05443a7616bdce19"
      username = "verica"
      groups   = ["system:masters"]
    }
  ]

  source  = "terraform-aws-modules/eks/aws"
  version = "18.20.5"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  # Per example here: https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/examples/fully-private-eks-cluster/main.tf
  # When creating a new cluster, create it first as public and then change to private
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = aws_iam_role.aws-ebs-csi-driver.arn
    }
  }

  enable_irsa = var.enable_irsa

  subnet_ids = var.private_subnets
  vpc_id     = var.vpc_id

  # eks_managed_node_group_defaults = {
  #   pre_bootstrap_user_data = local.ssm_userdata
  # }

  cluster_security_group_additional_rules = {
    ingress_node_to_cluster_tcp = {
      description                = "Allow all traffic from node across the cluster"
      protocol                   = "-1"
      from_port                  = 0
      to_port                    = 0
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress_cluster_to_node_tcp = {
      description                   = "Allow all traffic from the cluster to the node"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }

    ingress_all = {
      description = "Allow all traffic from the node to the node"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  eks_managed_node_groups = {
    default_node_group = {
      min_size     = 4
      max_size     = 6
      desired_size = 5

      instance_types = [var.node_instance_type]
      subnet_ids     = var.private_subnets
      vpc_id         = var.vpc_id
    }
  }
}

resource "aws_iam_policy" "policy" {
  description = "Policy for SSM"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetEncryptionConfiguration"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = var.tags
}

#IAM 
resource "aws_iam_role_policy_attachment" "additional" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.policy.arn
  role       = each.value.iam_role_name
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "aws-ebs-csi-driver-trust-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks.oidc_provider}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "aws-ebs-csi-driver" {
  name               = "${var.cluster_name}-aws-ebs-csi-controller"
  assume_role_policy = data.aws_iam_policy_document.aws-ebs-csi-driver-trust-policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "caws-ebs-csi-driver" {
  role = aws_iam_role.aws-ebs-csi-driver.name
  # From this reference: https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

## Install Fluentd Helm Chart
locals {
  name = "fluentd-http"

  labels = {
    k8s-app = "fluentd-http"
    version = "v1"
  }
}

resource "kubernetes_secret" "coralogix-keys" {
  metadata {
    name      = "coralogix-keys"
    namespace = "monitoring"
  }

  data = {
    PRIVATE_KEY = var.coralogix_write_key
  }
}

resource "helm_release" "fluentd_daemonset" {
  repository = "https://cgx.jfrog.io/artifactory/coralogix-charts-virtual"
  chart      = "fluentd-http"
  version    = "0.0.10"

  name            = "fluentd"
  namespace       = "monitoring"
  cleanup_on_fail = true

  values = [
    file("${path.module}/fluentd-override.yaml")
  ]

  depends_on = [
    kubernetes_secret.coralogix-keys
  ]
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
# Install the OpenTelemetry for Coralogix
resource "helm_release" "otel_coralogix" {
  repository = "https://cgx.jfrog.io/artifactory/coralogix-charts-virtual"
  chart      = "opentelemetry-coralogix"
  
  
  name       = "otel-coralogix"
  namespace = "monitoring"
  cleanup_on_fail = true
 
  values = [
    file("${path.module}/otel-override.yaml")
  ]

  depends_on = [
    kubernetes_secret.coralogix-keys
  ]

  set {
    name = "config.exporters.coralogix.private_key"
    value = var.coralogix_write_key
  }

}

resource "kubernetes_namespace" "open5gs" {
  metadata {
    name = "open5gs"
  }
}

resource "kubernetes_namespace" "ueransim" {
  metadata {
    name = "ueransim"
  }
}

resource "aws_s3_bucket" "cntf_open5gs_bucket_logs" {
  bucket = var.bucket_name_one
}

resource "aws_s3_bucket" "cntf_open5gs_bucket_metrics" {
  bucket = var.bucket_name_two
}

# resource "aws_s3_bucket" "cntf-open5gs-coralogix-test-results" {
#   bucket = var.bucket_name_three
# }

# resource "aws_s3_bucket" "cntf_open5gs_bucket_tfstate" {
#   bucket = var.bucket_name_four
# }

# ECR repository for custom ueransim image
# resource "aws_ecr_repository" "cntf-ueransim-puppeteer-ecr-repository" {
#   name                 = "var.aws_ecr_repository_name"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

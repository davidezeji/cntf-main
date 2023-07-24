terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.0"
    }
  }

  backend "s3" {
    encrypt = true
    bucket  = "cntf-tfstate-dish"
    key     = "infrastructure"
    region  = "us-east-1"
  }

  required_version = ">= 0.14"
}
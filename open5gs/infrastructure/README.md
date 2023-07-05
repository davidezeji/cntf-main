# Infrastructure Provisioning

To accurately test Open5GS's functionalities, a cloud infrastructure environment is needed to host its application components (5g network functions). Open5GS's infrastructure was created with the help of tools such as *AWS*, *Terraform*, and *GitLab CI*.

## Infrastructure components
* Kubernetes version: `> = 1.24`
* EKS Cluster: `minimum of 5 nodes with an instance type of "t2.medium" is desired.`
  
## EKS module 

This module contains the terraform configurations to create the cluster for Open5GS.

```
|- open5gs
   |- infrastructure
      |- eks
         |- main.tf: this file contains the main set of resource configurations for this module.
         |- outputs.tf: this file exports structured data about your resources. This data can be used to configure other parts of the infrastructure with automation tools.
         |- provider.tf: this file enables Terraform to work with multiple APIs such as those for AWS, Kubernetes, kubectl and helm.
         |- variables.tf: this file is where all module variables are declared.
         |- versions.tf: this file configures the versions of multiple terraform providers. Additionaaly, it defines the storage backend for the terraform state file (ex: AWS S3).

```
## CI/CD

Gitlab CI is the automation tool of choice for deploying Open5GS's infrastructure. The pipeline stages concerning infrastructure creation effectively test, build, deploy and destroy the resources defined by the terraform configurations in the EKS module.

```
stages:
  - validate
  - test
  - build
  - deploy
  - cleanup 

```

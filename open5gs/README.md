# Architecture

<img width="1274" alt="Screenshot 2023-09-12 at 2 09 24 PM" src="https://github.com/DISHDevEx/cntf/assets/82470009/6bfe7d27-2855-45e5-a80a-ffd7ca49d059">

## Documentation

* [Open5GS](https://github.com/DISHDevEx/open5gs)
* [UERANSIM](https://github.com/DISHDevEx/UERANSIM)
* [Coralogix](https://coralogix.com/)
* [OpenTelemetry](https://opentelemetry.io/)
* [FluentD](https://www.fluentd.org/)

## Automation
**Resources defined in Terraform:** 

* EKS cluster - Used to host Open5GS, UERANSIM and other applications
* S3 buckets - Used to store logs/metrics for test cases run on Open5GS
* S3 backend for terraform state - Defines an AWS S3 bucket to be used as the storage location for the terraform state file (this bucket must be created manually before the terraform code is deployed)
* ECR repository - Used to store the custom UERASIM docker image that runs puppeteer tests
* FluentD daemonset - Used to collect logs from resources running in the cluster and structure them in JSON format
Coralogix OpenTelemtry collector daemonset: Used to receive, process and export telemetry data to Coralogix

**Resources deployed by Gitlab CI pipeline:**

* Terraform - AWS infrastructure, applications and daemonsets
* 5g Core - Open5GS, Open source 5G core with a range of software components and network functionalities that realize the core functions of 4G/5G NSA (Non-Standalone) and 5G SA (Standalone).
* Test-suite - UERANSIM, Open source 5G UE and RAN (gNodeB) simulator
* Test cases - Smoke test 

**Pipeline Stages:**
* Validate - Formats and validates the written terraform code for syntax accuracy (“terraform fmt” and “terraform validate” commands happen here)
* Test - Tests both IaC and helm charts (Open5GS and UERANSIM) for errors/malware before install
* Build - Prepares terraform code for deployment (“terraform plan” command executes here)
* Deploy - Manual stage that deploys terraform code (“terraform apply” command executes here)
* Cleanup - Manual stage that destroys all things deployed via terraform (“terraform destroy” command executes here)
* Install_helm - Installs all necessary helm charts (Open5GS and UERANSIM) into the newly created EKS cluster
* Smoke_test - Random UE is created via UERANSIM and connects to Open5GS. UE curls a website while using an Open5GS interface to ensure the core network is operational.



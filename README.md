# CNTF - Main

## Purpose
This source code repository stores the configurations to create the necessary AWS infrastructure and applications (5G core & test suite) for CNTF.

## Deployment
Prerequisites:

* *Please ensure that you have configured the AWS CLI to authenticate to an AWS environment where you have adequate permissions to create an EKS cluster, security groups and IAM roles*: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html
* *Please ensure you have Gitlab runners set up (or are using shared runners): https://docs.gitlab.com/runner/register/*
* *Please ensure that the pipeline in this repository has been successfully deployed before executing those in other CNTF repositories, as this ensures that the AWS infrastructure, 5g core, and UERANSIM test suite are available to support the execution of scripts in other CNTF repositories.*  

Steps:
1. Mirror this repository in Gitlab or connect this repository externally to Gitlab 
2. Authenticate Gitlab with AWS: https://docs.gitlab.com/ee/ci/cloud_deployment/
3. Perform these actions inside of the Gitlab repository:
    * On the left side of the screen click the drop-down arrow next to "Build" and select "Pipelines"
    * In the top right hand corner select "Run Pipeline"
    * In the drop-down under "Run for branch name or tag" select the appropriate branch name and click "Run Pipeline"
    * Once again, click the drop-down arrow next to "Build" and select "Pipelines", you should now see the pipeline being executed
    
## Coralogix Dashboards
To view parsed & visualized data resulting from tests run by various CNTF repositories, please visit CNTF's dedicated Coralogix tenant: https://dish-wireless-network.atlassian.net/wiki/spaces/MSS/pages/543326302/Coralogix+BOAT+Change+Request 
    * Note: *You must have an individual account created by Coralogix to gain access to this tenant.*
    
Steps to view dashboards:
1. At the top of the page select the dropdown next to "Dashboards"
2. Select "Custom Dashboards" (All dashboards should have the tag "CNTF")

Raw data: To view raw data resulting from test runs, please look at the data stored in AWS S3 buckets dedicated to CNTF.


## Project Structure
```
├── coralogix_s3_setup                 contains configurations to setup s3 buckets for use by Coralogix 
|   └── README.md
|   └── s3_logs.json
|   └── s3_metrics.json
|
├── open5gs
|   ├── infrastructure                 contains infrastructure-as-code and helm configurations for open5gs & ueransim
|      	├── eks
|           └── fluentd-override.yaml  configures fluentd daemonset within the cluster
|           └── otel-override.yaml     configures opentelemtry daemonset within the cluster
|           └── provider.tf
|           └── main.tf                    
|           └── variables.tf                
|           └── outputs.tf 
|           └── versions.tf
|
└── .gitlab-ci.yml                     contains configurations to run CI/CD pipeline
|
└── README.md  
|
└── gitlab-runner-rbac.yaml            contains permissions to give gitlab runner(s) permissions to interact with kubernetes resources 
|
└── open5gs_values.yml                 these values files contain configurations to customize resources defined in the open5gs & ueransim helm charts
└── openverso_ueransim_gnb_values.yml                 
└── openverso_ueransim_ues_values.yml                                     
```

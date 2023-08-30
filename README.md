# CNTF

## Purpose
This source code repository deploys the AWS infrastructure and applications (5G core & test suite) for CNTF

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
|           └── provider.tf
|           └── main.tf                    
|           └── variables.tf                
|           └── outputs.tf 
|           └── versions.tf
|
└── .gitlab-ci.yml                     contains configurations to run CI/CD pipeline
|
└── README.md                          
```

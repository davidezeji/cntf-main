# CNTF

## Purpose
This source code repository deploys the AWS infrastructure and applications (5G core & test suite) for CNTF

## Project structure
```
├── coralogix_s3_setup                 contains configurations to setup s3 buckets for use by Coralogix 
|   └── README.md
|   └── s3_logs.json
|   └── s3_metrics.json
|
├── open5gs
|   ├── infrastructure                 contains infrastructure-as-code and helm configurations for open5gs & ueransim
|      	├── eks
            └── fluentd-override.yaml  configures fluentd daemonset within the cluster
            └── otel-override.yaml     configures opentelemtry daemonset within the cluster
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

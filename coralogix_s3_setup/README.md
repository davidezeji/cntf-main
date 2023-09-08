# CNTF/Coralogix Integration

## Data Storage 
Coralogix retrieves raw data from infrastructure and applications running in Kubernetes and stores them in AWS S3 buckets. To enable this, Coralogix requires the appropriate permissions to access your AWS S3 buckets. You can find the necessary code in the "s3_logs.json" and "s3_metrics.json" files in this directory. Simply insert this code into your S3 bucket policies, ensuring that you use the correct ARN numbers and Coralogix-specific code when applying these policies for the "cntf-open5gs-logs" and "cntf-open5gs-metrics" buckets.

***Refer to this documention for more details* (scroll down to "manual configuration"):* https://coralogix.com/docs/archive-s3-bucket-forever/ 

## Log Collection
To continuously send test data to Coralogix for parsing and visualization, set up an AWS Lambda function triggered whenever new logs are added to the dedicated S3 bucket ("cntf-open5gs-test-results").

**Options:**
* manual setup: https://coralogix.com/docs/data-collection-s3/
* Terraform: https://registry.terraform.io/modules/coralogix/aws/coralogix/latest/submodules/s3



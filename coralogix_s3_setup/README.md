# Coralogix S3 Logs & Metrics Configuration
Coralogix can give back raw data from infrastructure/apps running in the Kubernetes environment via AWS S3 buckets. To do this, they need adequate permissions to access your AWS S3 buckets. In this directory, the "s3_logs.json" and "s3_metrics.json" files contain the necessary code to insert into your S3 bucket policies (buckets: "cntf-open5gs-logs" and "cntf-open5gs-metrics"). When applying these policies, please make sure to use the correct "ARN" numbers and Coralogix code. 

***Refer to this documention for more details* (scroll down to "manual configuration"):* https://coralogix.com/docs/archive-s3-bucket-forever/ 

## AWS S3 Log Collection
To continuously send test data to be parsed & visualized by Coralogix, you will need an AWS Lambda function that gets triggered anytime new logs enter the dedicated S3 bucket(s) ("cntf-open5gs-test-results").

**Options:**
* Set up Lambda function manually: https://coralogix.com/docs/data-collection-s3/
* Set up Lambda function via Terraform: https://registry.terraform.io/modules/coralogix/aws/coralogix/latest/submodules/s3



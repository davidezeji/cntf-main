# Coralogix S3 Logs & Metrics Configuration
The "s3_logs.json" and "s3_metrics.json" files contain the JSON code to insert into your s3 bucket policies to allow Coralogix to store logs and metrics in each corresponding bucket. When applying these policies, please make sure to use the correct "ARN" numbers and coralogix code for your corresponding AWS region. 

***Please refer to this documention for more details* (scroll down to "manual configuration" section):* https://coralogix.com/docs/archive-s3-bucket-forever/ 

**Please refer to this documentation to use Terraform to set up Lambda triggers that retrieves logs & metrics from S3 and sends them to your Coralogix account:* https://registry.terraform.io/modules/coralogix/aws/coralogix/latest/submodules/s3

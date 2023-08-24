Follow these steps to correctly set up AWS S3 buckets to be used by Coralogix for the storage of logs & metrics: https://coralogix.com/docs/archive-s3-bucket-forever/

# S3_logs & S3_metrics Files
* These local files contain the json code to insert into your s3 bucket policies to allow Coralogix to store logs and metrics in each corresponding bucket.

**make sure to change the arn names for the correct bucket you are trying to use**
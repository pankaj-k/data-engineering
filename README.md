# Data Engineering With AWS
Implementation of the projects in the given book "Data Engineering With AWS" using Terraform.

Chapter 3:
The code creates a Lambda with Layer served via S3 bucket. 
It creates a trigger (file upload to Data landing S3 bucket) to start the lambda.
The role created can be assumed by Glue as well as Lambda.
You can manually create Glue jobs in Glue Studio.
Take this opportunity to learn more about Glue. You need to write Glue code rather than just copy pasting.
https://github.com/aws-samples/aws-glue-samples
https://catalog.us-east-1.prod.workshops.aws/workshops/ee59d21b-4cb8-4b3d-a629-24537cf37bb5/en-US/lab4/run-streaming-job


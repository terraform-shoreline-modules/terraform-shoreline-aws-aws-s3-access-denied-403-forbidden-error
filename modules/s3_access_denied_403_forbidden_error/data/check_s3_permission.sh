

#!/bin/bash



# Set the IAM user or role name as a variable

IAM_USER_OR_ROLE=${USER_OR_ROLE_ARN}



# Set the S3 bucket name as a variable

S3_BUCKET=${S3_BUCKET_ARN}



# Check the permission for the bucket

aws iam simulate-principal-policy --policy-source-arn $IAM_USER_OR_ROLE --action-names s3:ListBucket s3:GetObject --resource-arns $S3_BUCKET
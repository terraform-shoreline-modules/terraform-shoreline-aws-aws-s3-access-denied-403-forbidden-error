

#!/bin/bash







# Set the variables

policy_name=s3fullaccess

user_or_role_arn=${USER_OR_ROLE_ARN}

s3_bucket_arn=${S3_BUCKET_ARN}



# Create the policy

policy_arn=$(aws iam create-policy --policy-name $policy_name --policy-document '{

    "Version": "2012-10-17",

    "Statement": [

        {

            "Effect": "Allow",

            "Action": "s3:*",

            "Resource": "$s3_bucket_arn"

        }

    ]

}' --output text --query 'Policy.Arn')



# Attach the policy to the role

aws iam attach-role-policy --policy-arn $policy_arn --user-or-role-arn $user_or_role_arn



# Attach the policy to the user

aws iam attach-user-policy --policy-arn $policy_arn --user-or-role-arn $user_or_role_arn





echo "Policy $policy_name created and attached to $user_or_role_arn."
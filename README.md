
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# S3 Access Denied (403 Forbidden) Error.
---

This incident type occurs when a user or role is denied access to an S3 bucket due to HTTP error code 403, which indicates that the user or role does not have the necessary permissions to perform the requested action. This can happen when the user or role tries to access an S3 bucket that they do not have permissions for, or when their credentials have expired or been revoked. This can cause disruption to workflows that rely on data stored in the S3 bucket.

### Parameters
```shell
export BUCKET_NAME="PLACEHOLDER"

export USER_NAME="PLACEHOLDER"

export USER_OR_ROLE_ARN="PLACEHOLDER"

export S3_BUCKET_ARN="PLACEHOLDER"
```

## Debug

### List all S3 buckets
```shell
aws s3 ls
```

### Check if the region is correct
```shell
aws s3api get-bucket-location --bucket ${BUCKET_NAME}
```

### Check the bucket policy
```shell
aws s3api get-bucket-policy --bucket ${BUCKET_NAME}
```

### Check if the user's credentials are valid
```shell
aws sts get-caller-identity
```

### Check if the user has the required permissions
```shell
aws s3api list-objects --bucket ${BUCKET_NAME} --query 'Contents[].{Key: Key, Size: Size}'
```

### Check if the user has the correct IAM permissions
```shell
aws iam list-attached-user-policies --user-name ${USER_NAME}
```



### Check the IAM user or role that is being used to access the S3 bucket to verify that it has the necessary permissions.
```shell


#!/bin/bash



# Set the IAM user or role name as a variable

IAM_USER_OR_ROLE=${USER_OR_ROLE_ARN}



# Set the S3 bucket name as a variable

S3_BUCKET=${S3_BUCKET_ARN}



# Check the permission for the bucket

aws iam simulate-principal-policy --policy-source-arn $IAM_USER_OR_ROLE --action-names s3:ListBucket s3:GetObject --resource-arns $S3_BUCKET




```

## Repair

### Create a policy for s3FullAccess and attach to user or role
```shell


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


```
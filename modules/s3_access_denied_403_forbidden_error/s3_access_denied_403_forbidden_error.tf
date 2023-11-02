resource "shoreline_notebook" "s3_access_denied_403_forbidden_error" {
  name       = "s3_access_denied_403_forbidden_error"
  data       = file("${path.module}/data/s3_access_denied_403_forbidden_error.json")
  depends_on = [shoreline_action.invoke_check_s3_permission,shoreline_action.invoke_s3_policy_script]
}

resource "shoreline_file" "check_s3_permission" {
  name             = "check_s3_permission"
  input_file       = "${path.module}/data/check_s3_permission.sh"
  md5              = filemd5("${path.module}/data/check_s3_permission.sh")
  description      = "Check the IAM user or role that is being used to access the S3 bucket to verify that it has the necessary permissions."
  destination_path = "/tmp/check_s3_permission.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "s3_policy_script" {
  name             = "s3_policy_script"
  input_file       = "${path.module}/data/s3_policy_script.sh"
  md5              = filemd5("${path.module}/data/s3_policy_script.sh")
  description      = "Create a policy for s3FullAccess and attach to user or role"
  destination_path = "/tmp/s3_policy_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_s3_permission" {
  name        = "invoke_check_s3_permission"
  description = "Check the IAM user or role that is being used to access the S3 bucket to verify that it has the necessary permissions."
  command     = "`chmod +x /tmp/check_s3_permission.sh && /tmp/check_s3_permission.sh`"
  params      = ["S3_BUCKET_ARN","USER_OR_ROLE_ARN"]
  file_deps   = ["check_s3_permission"]
  enabled     = true
  depends_on  = [shoreline_file.check_s3_permission]
}

resource "shoreline_action" "invoke_s3_policy_script" {
  name        = "invoke_s3_policy_script"
  description = "Create a policy for s3FullAccess and attach to user or role"
  command     = "`chmod +x /tmp/s3_policy_script.sh && /tmp/s3_policy_script.sh`"
  params      = ["S3_BUCKET_ARN","USER_OR_ROLE_ARN"]
  file_deps   = ["s3_policy_script"]
  enabled     = true
  depends_on  = [shoreline_file.s3_policy_script]
}


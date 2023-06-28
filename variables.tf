variable "region" {
  type        = string
  description = "region to provision your infrastructure."
}
variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string

}
variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
}
variable "lambda_role" {
  description = " IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details."
  type        = string
}
variable "package_type" {
  description = "The Lambda deployment package type. Valid options: Zip or Image"
  type        = string
}
variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
}
variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
}
variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
}
variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1."
  type        = number
}
variable "runtime" {
  description = "Lambda Function runtime. Check valid runtimes https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
  type        = string
}
variable "lambda_at_edge" {
  description = "Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function"
  type        = bool
}
variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
}
variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
}
variable "kms_key_arn" {
  description = "The ARN of KMS key to use by your Lambda Function"
  type        = string
}
variable "image_uri" {
  description = "The ECR image URI containing the function's deployment package."
  type        = string
}
variable "architectures" {
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]."
  type        = list(string)
}
variable "filename" {
  type        = string
  description = "(Optional) Path to the function's deployment package within the local filesystem. Conflicts with image_uri, s3_bucket, s3_key, and s3_object_version."
}
variable "s3_bucket" {
  description = "S3 bucket to store artifacts"
  type        = string
}
variable "s3_key" {
  type        = string
  description = "(Optional) S3 key of an object containing the function's deployment package. Conflicts with filename and image_uri."
}
variable "s3_object_version" {
  type        = string
  description = "(Optional) Object version containing the function's deployment package. Conflicts with filename and image_uri."
}
variable "ephemeral_storage_size" {
  description = "Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB)."
  type        = number
}
variable "image_config_entry_point" {
  description = "The ENTRYPOINT for the docker image"
  type        = list(string)
}
variable "image_config_command" {
  description = "The CMD for the docker image"
  type        = list(string)
}
variable "image_config_working_directory" {
  description = "The working directory for the docker image"
  type        = string
}
variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
}
variable "dead_letter_target_arn" {
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails."
  type        = string
}
variable "tracing_mode" {
  description = "Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active."
  type        = string
}
variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
}
variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type        = list(string)
}
variable "file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon EFS Access Point that provides access to the file system."
  type        = string
}
variable "file_system_local_mount_path" {
  description = "The path where the function can access the file system, starting with /mnt/."
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}
resource "aws_lambda_function" "lambda" {
  function_name                  = var.function_name
  description                    = var.description
  role                           = var.lambda_role
  handler                        = var.package_type != "Zip" ? null : var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.package_type != "Zip" ? null : var.runtime
  layers                         = var.layers
  timeout                        = var.lambda_at_edge ? min(var.timeout, 30) : var.timeout
  publish                        = var.lambda_at_edge ? true : var.publish
  kms_key_arn                    = var.kms_key_arn
  image_uri                      = var.image_uri
  package_type                   = var.package_type
  architectures                  = var.architectures

  filename          = "${path.module}/myzip/${var.filename}"
  s3_bucket         = length(var.filename) == 0 ? var.s3_bucket : null
  s3_key            = length(var.filename) == 0 ? var.s3_key : null
  s3_object_version = length(var.filename) == 0 ? var.s3_object_version : null


  /* ephemeral_storage is not supported in gov-cloud region, so it should be set to `null` */
  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size == null ? [] : [true]

    content {
      size = var.ephemeral_storage_size
    }
  }

  dynamic "image_config" {
    for_each = length(var.image_config_entry_point) > 0 || length(var.image_config_command) > 0 || var.image_config_working_directory != null ? [true] : []
    content {
      entry_point       = var.image_config_entry_point
      command           = var.image_config_command
      working_directory = var.image_config_working_directory
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [true]
    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    security_group_ids = ["sg-0c8b64f0e9d99a984"]
    subnet_ids         = ["subnet-03a3d869c130c375d", "subnet-08fc5a07032996138"]
  }


  dynamic "file_system_config" {
    for_each = var.file_system_arn != null && var.file_system_local_mount_path != null ? [true] : []
    content {
      local_mount_path = var.file_system_local_mount_path
      arn              = var.file_system_arn
    }
  }

  tags = var.tags
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
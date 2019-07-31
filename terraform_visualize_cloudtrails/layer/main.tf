terraform {
  required_version = ">= 0.11.7"
}

module "aws_resources_module_network" {
  source  = "../module_network"

  providers = {
    "aws"  = "aws.shared_services"
  }
  common_tags = "${var.common_tags}"
}

module "aws_resources_module_ec2" {
  source  = "../module_ec2"

  providers = {
    "aws"  = "aws.shared_services"
  }

  common_tags = "${var.common_tags}"
  vpc_zone_identifier = "${module.aws_resources_module_network.demo_subnet_private}"
  public_subnets = "${module.aws_resources_module_network.demo_subnet_public}"
  vpc_security_group_ids = "${module.aws_resources_module_network.demo_security_group}"
  acm_domain_name = "*.tuiuki.io"
  vpc_id = "${module.aws_resources_module_network.demo_vpc_id}"
}

module "aws_resources_module_cognito" {
  source  = "../module_cognito"

  providers = {
    "aws"  = "aws.shared_services"
  }
  common_tags = "${var.common_tags}"
}

module "aws_resources_module_s3" {
  source  = "../module_s3"

  providers = {
    "aws"  = "aws.shared_services"
  }
  common_tags = "${var.common_tags}"
}

module "aws_resources_module_cloudwatch_logs" {
  source  = "../module_cloudwatch_logs"

  providers = {
    "aws"  = "aws.shared_services"
  }
  common_tags = "${var.common_tags}"
}

module "aws_resources_module_vpcflow_logs" {
  source  = "../module_vpcflow_logs"

  providers = {
    "aws"  = "aws.shared_services"
  }

  common_tags = "${var.common_tags}"
  vpc_id = "${module.aws_resources_module_network.demo_vpc_id}"
  log_destination_arn = "${module.aws_resources_module_cloudwatch_logs.cloud_watch_logs_group_arn_vpcflow}"
}

module "aws_resources_module_cloudtrail" {
  source  = "../module_cloudtrail"

  providers = {
    "aws"  = "aws.shared_services"
  }

  common_tags = "${var.common_tags}"
  s3_bucket_arn = "${module.aws_resources_module_s3.s3_bucket_arn}"
  s3_bucket_name = "${module.aws_resources_module_s3.s3_bucket_name}"
  # cloud_watch_logs_group_arn_cloudtrail = "${module.aws_resources_module_cloudwatch_logs.cloud_watch_logs_group_arn_cloudtrail}"
  # cloud_watch_logs_role_arn = "${module.aws_resources_module_cloudwatch_logs.cloud_watch_logs_role_arn}"

  depends_on = ["${module.aws_resources_module_s3.s3_block_public_access_id}"]
}

module "aws_resources_module_es" {
  source  = "../module_es"

  providers = {
    "aws"  = "aws.shared_services"
  }

  common_tags = "${var.common_tags}"
  es_subnet_ids = "${module.aws_resources_module_network.demo_subnet_public}"
  security_group_ids = "${module.aws_resources_module_network.demo_security_group}"
  cognito_user_pool_id = "${module.aws_resources_module_cognito.cognito_user_pool_id}"
  cognito_user_pool_endpoint = "${module.aws_resources_module_cognito.cognito_user_pool_endpoint}"
  cognito_identity_pool_id = "${module.aws_resources_module_cognito.cognito_identity_pool_id}"
  cognito_iam_role_arn = "${module.aws_resources_module_cognito.cognito_iam_role_arn}"
  depends_on = ["${module.aws_resources_module_cognito.cognito_identity_pool_roles_attachment_id}"]
}

module "aws_resources_module_lambda_layer" {
  source  = "../module_lambda_layer"

  providers = {
    "aws"  = "aws.shared_services"
  }
}

module "aws_resources_module_lambda" {
  source  = "../module_lambda"

  providers = {
    "aws"  = "aws.shared_services"
  }
  
  common_tags = "${var.common_tags}"
  cognito_user_pool_id = "${module.aws_resources_module_cognito.cognito_user_pool_id}"
  es_endpoint = "${module.aws_resources_module_es.es_endpoint}"
  cloud_watch_logs_group_arn_vpcflow = "${module.aws_resources_module_cloudwatch_logs.cloud_watch_logs_group_arn_vpcflow}"
  lambda_layer_python_arn = "${module.aws_resources_module_lambda_layer.demo_lambda_layer_python3_version_arn}"
  s3_bucket_arn = "${module.aws_resources_module_s3.s3_bucket_arn}"
  s3_bucket_name = "${module.aws_resources_module_s3.s3_bucket_name}"
  
  depends_on = ["${module.aws_resources_module_lambda_layer.demo_lambda_layer_python3_version_arn}"]
  # cloud_watch_logs_group_arn_cloudtrail = "${module.aws_resources_module_cloudwatch_logs.cloud_watch_logs_group_arn_cloudtrail}"
  # cloud_watch_logs_role_arn = "${module.aws_resources_module_cloudwatch_logs.cloud_watch_logs_role_arn}"
}

module "aws_resources_module_s3_events" {
  source  = "../module_s3_events"

  providers = {
    "aws"  = "aws.shared_services"
  }

  common_tags = "${var.common_tags}"
  s3_bucket_name = "${module.aws_resources_module_s3.s3_bucket_name}"
  cloudtrail_logstoelasticsearch_lambda_function_arn = "${module.aws_resources_module_lambda.lambda_function_cloudtrail_logstoelasticsearch_arn}"
}

module "aws_resources_module_cloudwatch_log_subscription" {
  source  = "../module_cloudwatch_log_subscription"

  providers = {
    "aws"  = "aws.shared_services"
  }
  cloud_watch_logs_group_name_cloudtrail = "${module.aws_resources_module_cloudwatch_logs.cloud_watch_logs_group_name_cloudtrail}"
  cloud_watch_logs_group_name_vpcflow = "${module.aws_resources_module_cloudwatch_logs.cloud_watch_logs_group_name_vpcflow}"
  lambda_cwlpolicyforstreaming_role_arn = "${module.aws_resources_module_lambda.lambda_cwlpolicyforstreaming_role_arn}"
  lambda_function_vpcflow_logstoelasticsearch_arn = "${module.aws_resources_module_lambda.lambda_function_vpcflow_logstoelasticsearch_arn}"
  lambda_function_cloudtrail_logstoelasticsearch_arn = "${module.aws_resources_module_lambda.lambda_function_cloudtrail_logstoelasticsearch_arn}"
}
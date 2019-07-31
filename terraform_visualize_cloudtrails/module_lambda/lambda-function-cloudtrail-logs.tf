resource "aws_lambda_function" "demo-lambda-cloudtrail-logstoelasticsearch" {
    filename         = "../module_lambda/lambda_function/terraform-demo-lambda-cloudtrail-logstoelasticsearch.zip"
    function_name    = "terraform-demo-lambda-cloudtrail-logstoelasticsearch"
    description      = "CloudWatch Logs to Amazon ES streaming"
    role             = "${aws_iam_role.demo-iam-role-lambda-cloudtrail-logstoelasticsearch.arn}"
    handler          = "index.lambda_handler"
    source_code_hash = "${filebase64sha256("../module_lambda/lambda_function/terraform-demo-lambda-cloudtrail-logstoelasticsearch.zip")}"
    runtime          = "python3.7"
    timeout          = "300"
    memory_size      = "128"

    environment {
        variables = {
            ES_HOST = "${var.es_endpoint}"
        }
    }

    layers = ["${var.lambda_layer_python_arn}"]

    tags = "${var.common_tags}"
}

resource "aws_lambda_permission" "demo-lambda-permission-cloudtrail-logstoelasticsearch" {
  statement_id = "terraform-demo-lambda-permission-cloudtrail-logs-cloudwatch-allow"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.demo-lambda-cloudtrail-logstoelasticsearch.arn}"
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::terraform-demo-735276988266-s3-cloudtrail-logging"
}
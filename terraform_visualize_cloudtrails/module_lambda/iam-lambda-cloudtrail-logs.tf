##############################################################################

resource "aws_iam_role" "demo-iam-role-lambda-cloudtrail-logstoelasticsearch" {
  name = "terraform-demo-iam-role-lambda-cloudtrail-logstoelasticsearch"

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

resource "aws_iam_role_policy" "demo-iam-role-policy-lambda-cloudtrail-logstoelasticsearch" {
  name = "terraform-demo-iam-role-policy-lambda-cloudtrail-logstoelasticsearch"
  role = "${aws_iam_role.demo-iam-role-lambda-cloudtrail-logstoelasticsearch.id}"

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
            "Resource": [
                "arn:aws:logs:*:*:*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": "es:ESHttpPost",
            "Resource": "arn:aws:es:*:*:*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "demo-iam-role-policy-attachment-AWSLambdaVPCAccessExecutionRole" {
  role       = "${aws_iam_role.demo-iam-role-lambda-cloudtrail-logstoelasticsearch.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_iam_role_policy_attachment" "demo-iam-role-policy-attachment-AmazonS3ReadOnlyAccess" {
  role       = "${aws_iam_role.demo-iam-role-lambda-cloudtrail-logstoelasticsearch.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
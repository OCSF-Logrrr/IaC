# lambda.tf

resource "aws_lambda_function" "SendToKafkaFunction" {
  function_name = "SendToKafkaFunction"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  s3_bucket     = "logrrr-lambda-code-bucket"
  s3_key        = "SendToKafkaFunction.py.zip"
  timeout       = 30
}

resource "aws_lambda_event_source_mapping" "guardduty_sqs_trigger" {
  event_source_arn = var.guardduty_sqs_queue_arn
  function_name    = aws_lambda_function.SendToKafkaFunction.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_iam_role" "lambda_exec" {
  name = "guardduty_lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaSQSQueueExecutionRole"
}
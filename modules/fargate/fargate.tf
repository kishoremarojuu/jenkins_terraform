
resource "aws_ecs_cluster" "jenkins_agent" {
  name               = "${var.name_prefix}-fg-cluster"
  capacity_providers = ["FARGATE"]
  tags               = var.tags

  # setting {
  #   name = "containerInsights"
  #   value = false
  # }
}

resource "aws_kms_key" "jenkins_agent" {
  description = "KMS for cloudwatch log group"
  policy      = data.aws_iam_policy_document.cloudwatch.json

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "jenkins_agent" {
  name              = "jenkins_agent"
  retention_in_days = 3
  kms_key_id        = aws_kms_key.jenkins_agent.arn
  tags              = var.tags
}
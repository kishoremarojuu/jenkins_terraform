// policy document for assuming for remote role
data "aws_iam_policy_document" "jenkins_agent_ecr_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.ecr_account_id}:role/serverless-jenkins-ivd-agent"]
    }
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "jenkins_agent_ecr_assume_role" {
  count  = var.create_ecs_task_def_for_agents ? 1 : 0

  name               = "${var.name_prefix}-jenkins-agent-ecr-assume-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_agent_ecr_assume_policy.json
  tags               = var.tags
}

// Container Definition for java agent
locals {
    jenkins_java_agent_def = templatefile("${path.module}/templates/jenkins-java-agent.json.tpl", {
    name                    = "jenkins-java-agent"
    container_image         = "871244369079.dkr.ecr.us-west-2.amazonaws.com/ivd-serverless-jenkins" #CHANGEME
    cpu                     = 512
    memory                  = 1024
  })
}

resource "aws_ecs_task_definition" "jenkins_java_agent" {
  count  = var.create_ecs_task_def_for_agents ? 1 : 0

  family                   = "jenkins-java-agent"
  execution_role_arn       = var.create_ecs_task_def_for_agents ? aws_iam_role.jenkins_agent_ecr_assume_role[0].arn : null
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  container_definitions    = local.jenkins_java_agent_def

  tags = var.tags
}

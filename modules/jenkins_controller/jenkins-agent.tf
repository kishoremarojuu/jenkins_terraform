// ECS Task execution role for Jenkins Agents
data "aws_iam_policy_document" "jenkins_agent_assume_policy" {
   statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::461415053208:root", "arn:aws:iam::602710607084:root"]  ##CHANGEME
    }
  }
}

data "aws_iam_policy_document" "jenkins_agent_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "jenkins_agent_execution_role" {
  count  = var.create_ecs_task_def_for_agents ? 1 : 0

  name               = "${var.name_prefix}-jenkins-agent-execution-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_agent_assume_policy.json
  tags               = var.tags
}

resource "aws_iam_policy" "jenkins_agent_execution_policy" {
  count  = var.create_ecs_task_def_for_agents ? 1 : 0

  name   = "${var.name_prefix}-jenkins-agent-execution-policy"
  policy = data.aws_iam_policy_document.jenkins_agent_execution_policy.json
}

resource "aws_iam_role_policy_attachment" "jenkins_agent_execution" {
  count  = var.create_ecs_task_def_for_agents ? 1 : 0

  role       = var.create_ecs_task_def_for_agents ? aws_iam_role.jenkins_agent_execution_role[0].name : null
  policy_arn = var.create_ecs_task_def_for_agents ? aws_iam_policy.jenkins_agent_execution_policy[0].arn : null
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
  execution_role_arn       = var.create_ecs_task_def_for_agents ? aws_iam_role.jenkins_agent_execution_role[0].arn : null
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  container_definitions    = local.jenkins_java_agent_def

  tags = var.tags
}
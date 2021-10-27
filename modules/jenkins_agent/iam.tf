// Assume role for Jenkins master
data "aws_iam_policy_document" "jenkins_controller_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.jenkins_controller_account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "jenkins_controller_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "jenkins_controller_policy" {
  name   = "${var.name_prefix}-controller-policy"
  policy = data.aws_iam_policy_document.jenkins_controller_policy.json
}

resource "aws_iam_role" "jenkins_controller_role" {
  name               = "jenkins-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_controller_assume_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "jenkins_controller_task" {
  role       = aws_iam_role.jenkins_controller_role.name
  policy_arn = aws_iam_policy.jenkins_controller_policy.arn
}
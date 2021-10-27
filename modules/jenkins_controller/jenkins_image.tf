data "aws_ecr_authorization_token" "token" {}

locals {
  ecr_endpoint = split("/", aws_ecr_repository.jenkins_controller.repository_url)[0]
}


resource "aws_ecr_repository" "jenkins_controller" {
  name                 = var.jenkins_ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

}

# data "template_file" "jenkins_configuration_def" {

#   template = file("${path.module}/docker/files/jenkins.yaml.tpl")

#   vars = {
#     ecs_cluster_fargate          = aws_ecs_cluster.jenkins_controller.arn
#     cluster_region               = local.region
#     jenkins_cloud_map_name       = "controller.${var.name_prefix}"
#     jenkins_controller_port      = var.jenkins_controller_port
#     jnlp_port                    = var.jenkins_jnlp_port
#     agent_security_groups        = aws_security_group.jenkins_controller_security_group.id
#     subnets                      = join(",", var.jenkins_controller_subnet_ids)
#     jenkins_jnlp_endpoint        = aws_lb.jnlp.dns_name
#     jenkins_http_endpoint        = aws_lb.this.dns_name
#     remote_agent_subnets         = var.remote_agent_subnets
#     remote_agent_security_groups = var.remote_agent_security_groups
#     remote_agent_account_id      = var.remote_agent_account_id
#     remote_agent_ecs_cluster_name = var.remote_agent_ecs_cluster_name
#   }
# }

locals {
  jenkins_configuration_def = templatefile("${path.module}/docker/files/jenkins.yaml.tpl", {
    ecs_cluster_fargate               = aws_ecs_cluster.jenkins_controller.arn
    cluster_region                    = local.region
    jenkins_cloud_map_name            = "controller.${var.name_prefix}"
    jenkins_controller_port           = var.jenkins_controller_port
    jnlp_port                         = var.jenkins_jnlp_port
    agent_security_groups             = aws_security_group.jenkins_controller_security_group.id
    subnets                           = join(",", var.jenkins_controller_subnet_ids)
    jenkins_jnlp_endpoint             = aws_lb.jnlp.dns_name
    jenkins_http_endpoint             = aws_lb.this.dns_name
    remote_agent_subnets              = var.remote_agent_subnets
    remote_agent_security_groups      = var.remote_agent_security_groups
    remote_agent_account_id           = var.remote_agent_account_id
    remote_agent_ecs_cluster_name     = var.remote_agent_ecs_cluster_name
    remote_agent_fargate_cluster_name = var.remote_agent_fargate_cluster_name
  })
}

resource "null_resource" "render_template" {
  triggers = {
    src_hash = file("${path.module}/docker/files/jenkins.yaml.tpl")
  }
  depends_on = [local.jenkins_configuration_def]

  provisioner "local-exec" {
    command = <<EOF
tee ${path.module}/docker/files/jenkins.yaml <<ENDF
${local.jenkins_configuration_def}
EOF
  }
}

resource "null_resource" "build_docker_image" {
  triggers = {
    src_hash = file("${path.module}/docker/files/jenkins.yaml.tpl")
  }
  depends_on = [null_resource.render_template]
  provisioner "local-exec" {
    command = <<EOF
docker login -u AWS -p ${data.aws_ecr_authorization_token.token.password} ${local.ecr_endpoint} && \
docker build -t ${aws_ecr_repository.jenkins_controller.repository_url}:latest ${path.module}/docker/ && \
# Comment above line and Uncomment below line to Build in Apple M1 Machines
#docker buildx  build -t ${aws_ecr_repository.jenkins_controller.repository_url}:latest ${path.module}/docker/ --platform linux/amd64 && \
docker push ${aws_ecr_repository.jenkins_controller.repository_url}:latest
EOF
  }
}

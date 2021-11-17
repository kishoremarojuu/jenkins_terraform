jenkins:
    systemMessage: "AWS ECS/FARGATE Demo"
    numExecutors: 0
    remotingSecurity:
      enabled: true
    agentProtocols:
        - "JNLP4-connect"
    securityRealm:
        local:
            allowsSignup: false
            users:
                - id: ecsuser
                  password: \$${ADMIN_PWD}
    authorizationStrategy:
        globalMatrix:
            grantedPermissions:
                - "Overall/Read:authenticated"
                - "Job/Read:authenticated"
                - "View/Read:authenticated"
                - "Overall/Administer:authenticated"
    crumbIssuer: "standard"
    slaveAgentPort: 50000
    clouds:
        - ecs:
              allowedOverrides: "inheritFrom,label,memory,cpu,image"
              credentialsId: ""
              cluster: ${ecs_cluster_fargate}
              name: "fargate-cloud"
              regionName: ${cluster_region}
              retentionTimeout: 10
              jenkinsUrl: "http://${jenkins_cloud_map_name}:${jenkins_controller_port}"
              templates:
                  - cpu: "512"
                    image: "jenkins/inbound-agent"
                    label: "build-example"
                    launchType: "FARGATE"
                    memory: 0
                    memoryReservation: 1024
                    networkMode: "awsvpc"
                    privileged: false
                    remoteFSRoot: "/home/jenkins"
                    securityGroups: ${agent_security_groups}
                    sharedMemorySize: 0
                    subnets: ${subnets}
                    templateName: "build-example"
                    uniqueRemoteFSRoot: false
        - ecs:
              allowedOverrides: "inheritFrom,label,memory,cpu,image"
              credentialsId: ""
              cluster: "arn:aws:ecs:us-west-2:${remote_agent_account_id}:cluster/${remote_agent_ecs_cluster_name}"
              name: "ecs-cloud-remote"
              assumedRoleArn: "arn:aws:iam::${remote_agent_account_id}:role/jenkins-deploy-role"
              regionName: ${cluster_region}
              retentionTimeout: 10
              tunnel: ${jenkins_jnlp_endpoint}:${jnlp_port}
              jenkinsUrl: "http://${jenkins_http_endpoint}"
              templates:
                  - cpu: "512"
                    image: "jenkins/inbound-agent"
                    label: "ecs-remote"
                    launchType: "EC2"
                    memory: 0
                    memoryReservation: 1024
                    networkMode: "awsvpc"
                    privileged: false
                    remoteFSRoot: "/home/jenkins"
                    securityGroups: ${remote_agent_security_groups}
                    sharedMemorySize: 0
                    subnets: ${remote_agent_subnets}
                    templateName: "ecs-remote"
                    uniqueRemoteFSRoot: false
        - ecs:
              allowedOverrides: "inheritFrom,label,memory,cpu,image"
              credentialsId: ""
              cluster: "arn:aws:ecs:us-west-2:${remote_agent_account_id}:cluster/${remote_agent_fargate_cluster_name}"
              name: "fargate-cloud-remote"
              assumedRoleArn: "arn:aws:iam::${remote_agent_account_id}:role/jenkins-deploy-role"
              regionName: ${cluster_region}
              retentionTimeout: 10
              tunnel: ${jenkins_jnlp_endpoint}:${jnlp_port}
              jenkinsUrl: "http://${jenkins_http_endpoint}"
              templates:
                  - cpu: "512"
                    image: "jenkins/inbound-agent"
                    label: "fargate-remote"
                    launchType: "FARGATE"
                    memory: 0
                    memoryReservation: 1024
                    networkMode: "awsvpc"
                    privileged: false
                    remoteFSRoot: "/home/jenkins"
                    securityGroups: ${remote_agent_security_groups}
                    sharedMemorySize: 0
                    subnets: ${remote_agent_subnets}
                    templateName: "fargate-remote"
                    uniqueRemoteFSRoot: false
security:
  sSHD:
    port: -1
jobs:
  - script: >
      pipelineJob('Simple job local task') {
        definition {
          cps {
            script('''
              pipeline {
                  agent {
                      ecs {
                          inheritFrom 'build-example'
                      }
                  }
                  stages {
                    stage('Test') {
                        steps {
                            script {
                                sh "echo this was executed on local Fargate cluster"
                            }
                            sh 'sleep 20'
                            sh 'echo sleep is done'
                        }
                    }
                  }
              }'''.stripIndent())
              sandbox()
          }
        }
      }
  - script: >
      pipelineJob('Simple job ECS remote task') {
        definition {
          cps {
            script('''
              pipeline {
                  agent {
                      ecs {
                          inheritFrom 'ecs-remote'
                      }
                  }
                  stages {
                    stage('Test') {
                        steps {
                            script {
                                sh "echo this was executed on remote ECS Cluster"
                            }
                            sh 'sleep 20'
                            sh 'echo sleep is done'
                        }
                    }
                  }
              }'''.stripIndent())
              sandbox()
          }
        }
      }
  - script: >
      pipelineJob('Simple job FARGATE remote task') {
        definition {
          cps {
            script('''
              pipeline {
                  agent {
                      ecs {
                          inheritFrom 'fargate-remote'
                      }
                  }
                  stages {
                    stage('Test') {
                        steps {
                            script {
                                sh "echo this was executed on a remote FARGATE cluster"
                            }
                            sh 'sleep 20'
                            sh 'echo sleep is done'
                        }
                    }
                  }
              }'''.stripIndent())
              sandbox()
          }
        }
      }

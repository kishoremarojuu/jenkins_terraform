jenkins:
    systemMessage: "AWS ECS/FARGATE Demo"
    numExecutors: 0
    remotingSecurity:
      enabled: true
    agentProtocols:
        - "JNLP4-connect"
    securityRealm:
        saml:
          binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
          displayNameAttributeName: "displayname"
          emailAttributeName: "email"
          groupsAttributeName: "group"
          idpMetadataConfiguration:
            period: 0
            url: "https://invitae-test.okta.com/app/exk50eir9avvgW8Qf4x7/sso/saml/metadata"
            xml: |-
              <?xml version="1.0" encoding="UTF-8"?>
              <md:EntityDescriptor entityID="http://www.okta.com/exk50eir9avvgW8Qf4x7"
                  xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata">
                  <md:IDPSSODescriptor WantAuthnRequestsSigned="false" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
                      <md:KeyDescriptor use="signing">
                          <ds:KeyInfo
                              xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
                              <ds:X509Data>
                                  <ds:X509Certificate>MIIDqDCCApCgAwIBAgIGAXQkUEkcMA0GCSqGSIb3DQEBCwUAMIGUMQswCQYDVQQGEwJVUzETMBEG
              A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
              MBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGludml0YWUtdGVzdDEcMBoGCSqGSIb3DQEJ
              ARYNaW5mb0Bva3RhLmNvbTAeFw0yMDA4MjUwNjMwMTVaFw0zMDA4MjUwNjMxMTVaMIGUMQswCQYD
              VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsG
              A1UECgwET2t0YTEUMBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDGludml0YWUtdGVzdDEc
              MBoGCSqGSIb3DQEJARYNaW5mb0Bva3RhLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
              ggEBAJyA3SReWvH0ws+C6NfieZK7sVyaXKJaNxRi0N7wILmMYVON/z1J6IjuwMszR0f/NV/C+efR
              zg1hOhWfNXPYQG977R/PtUpmhXNnv0Ye7Dkl13nl8NqxFzZ3WOsRqyZZP7frqgEJ0REyu2MHSCBm
              tU8mTTRSSPs3cSIVDhvESXvpvKsqim151sS3wDQm+Ezs5IKgT1yC3eVQGjAdDoPWCXdReROa2rEL
              cvEygfPoREFCdUf0I89pO6gKLbbvGSbpMy03E5MSPijRQD4KbA3yIBsn7mn4AmncE0WCkRXAumnD
              n6RAW4xXOFDNvMx0dx9ZqvZlf+ttdzd4OGyJbO62/QMCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEA
              De+WaQDBrzzGB6YyN3fCUhj6gi4PvkNt0jPce6yITkCyuNayXVsxEl+S6z6KEn9l8niNHXQpX3yx
              KTEH1ellxt3qFKpE9oOLUJN4iV9lrA3tEu0YNMxF0J02pQ9CIxYOJuJYZZayfQ70h+SAI9hOGPrr
              PZ//D3NkYe7mv/JvEVJhH7nwkjRnzLZaYBIXuM4TvFO58dVBcv9AoTUTZ9kiArVCJl0DO9p5nx5c
              5CMKVrFl+F0aY3VuY/8jV+r21pui2mbr1lRYbsNuVNbeptF8Ca8afXUXue4gp6i7Ux0oviex1DRY
              ZEOxskknXyu+TMMF5JG5/yjHJl0trSADDxJl3g==</ds:X509Certificate>
                              </ds:X509Data>
                          </ds:KeyInfo>
                      </md:KeyDescriptor>
                      <md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</md:NameIDFormat>
                      <md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat>
                      <md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://invitae-test.okta.com/app/jenkins/exk50eir9avvgW8Qf4x7/sso/saml"/>
                      <md:SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://invitae-test.okta.com/app/jenkins/exk50eir9avvgW8Qf4x7/sso/saml"/>
                  </md:IDPSSODescriptor>
              </md:EntityDescriptor>
          maximumAuthenticationLifetime: 86400
          usernameAttributeName: "username"
          usernameCaseConversion: "lowercase"
    authorizationStrategy:
        roleBased:
          roles:
            global:
              - name: "admin"
                description: "Jenkins administrators"
                permissions:
                  - "Overall/Administer"
                assignments:
                  - "admin"
              - name: "Jenkins - ADX POC"
                description: "Jenkins - ADX POC Users"
                permissions:
                  - "Overall/Administer"
                assignments:
                  - "authenticated"
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

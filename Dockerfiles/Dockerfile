#Custom
FROM 784480553225.dkr.ecr.us-west-2.amazonaws.com/core-build:latest

ARG VERSION=4.11.2
RUN yum install -y java-11 \
  && curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

## git installation
RUN yum install -y git

##pyyaml installation
RUN pip install pyyaml

# Setting Maven Version that needs to be installed
ARG MAVEN_VERSION=3.5.4
# Changing user to root to install maven
USER root
# Install required tools
# which: otherwise 'mvn version' prints '/usr/share/maven/bin/mvn: line 93: which: command not found'
RUN yum update -y && \
  yum install -y which && \
  yum clean all
# Maven
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV M2_HOME /usr/share/maven
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH
CMD ["mvn","-version"]

##docker installation
FROM jenkins/jenkins:lts
USER root
RUN curl -sSL https://get.docker.com/ | sh
USER jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
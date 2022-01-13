docker build -t ivd-serverless-jenkins .
docker tag ivd-serverless-jenkins:latest 871244369079.dkr.ecr.us-west-2.amazonaws.com/ivd-serverless-jenkins:latest
docker push 871244369079.dkr.ecr.us-west-2.amazonaws.com/ivd-serverless-jenkins:latest
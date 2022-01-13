aws ecr get-login-password --region us-west-2 --profile 871244369079MasterController | docker login --username AWS --password-stdin 871244369079.dkr.ecr.us-west-2.amazonaws.com
aws ecr get-login-password --region us-west-2 --profile ivdAccount | docker login --username AWS --password-stdin 784480553225.dkr.ecr.us-west-2.amazonaws.com
docker build -t ivd-serverless-jenkins .
docker tag ivd-serverless-jenkins:latest 871244369079.dkr.ecr.us-west-2.amazonaws.com/ivd-serverless-jenkins:latest
docker push 871244369079.dkr.ecr.us-west-2.amazonaws.com/ivd-serverless-jenkins:latest
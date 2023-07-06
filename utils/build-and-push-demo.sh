#!/bin/bash
###############################
# Tiago França | https://tiagofranca.com
# 2023-07-05
###############################

FILE_PATH=$(readlink -f "${0}")
FILE_DIR=$(dirname "${FILE_PATH}");
BASE_DIR=$(realpath "${FILE_DIR}/../")

# echo "FILE_PATH: ${FILE_PATH}";
# echo "FILE_DIR: ${FILE_DIR}";
echo ""
echo "BASE_DIR: ${BASE_DIR}";
echo ""

cd "${BASE_DIR}"

DATE=$(date +%y%m%d%H%M%S)
PHP_VERSION=8.1
LAMBDA_NAME= ## Ex: SQSTestePHP8
LOCAL_IMAGE_NAME= ## Ex: tiagofranca/base-aws-php
AWS_IMAGE_NAME= ## Ex: base-aws-php
ACCOUNT_ID= ## Ex: 029618464094
DATE_IMAGE_TAG="${PHP_VERSION}.${DATE}"
AWS_IMAGE_TAG="${AWS_IMAGE_TAG:-${DATE_IMAGE_TAG}}"

if [ -z $LAMBDA_NAME ]; then
    echo -e "LAMBDA_NAME env is required\n"
    exit 9;
fi
echo -e "LAMBDA_NAME: ${LAMBDA_NAME}"

if [ -z $AWS_IMAGE_NAME ]; then
    echo -e "AWS_IMAGE_NAME env is required\n"
    exit 9;
fi
echo -e "AWS_IMAGE_NAME: ${AWS_IMAGE_NAME}"

if [ -z $ACCOUNT_ID ]; then
    echo -e "ACCOUNT_ID env is required\n"
    exit 9;
fi
echo -e "ACCOUNT_ID: ${ACCOUNT_ID}"

if [ -z $AWS_IMAGE_TAG ]; then
    echo -e "AWS_IMAGE_TAG env is required\n"
    exit 5;
else
    echo -e "Tag: ${AWS_IMAGE_TAG}"
fi

if [ -z $AWS_IMAGE_TAG ]; then
    echo -e "AWS_IMAGE_TAG env is required\n"
    exit 5;
else
    echo -e "Tag: ${AWS_IMAGE_TAG}"
fi

#### Define build values
AWS_ECR_URI="${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
AWS_ECR_IMAGE_URI="${AWS_ECR_URI}/${AWS_IMAGE_NAME}"
DOCKER_TAG=${DOCKER_TAG:-latest};
#### END Define build values

## Login on ECR Docker registry
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ECR_URI}

if [ $? !-ne 0 ]; then
    echo -e "Fail to login on AWS ECR"
fi

docker build -t ${LOCAL_IMAGE_NAME}:${PHP_VERSION} .

docker tag ${LOCAL_IMAGE_NAME}:${PHP_VERSION} ${AWS_ECR_IMAGE_URI}:${AWS_IMAGE_TAG}

docker push ${AWS_ECR_IMAGE_URI}:${AWS_IMAGE_TAG}

notify-send 'build' -u low -t 500 > /dev/null 2>&1 || echo 'Finished'

## Deploy lambda
# aws lambda update-function-code --function-name ${LAMBDA_NAME} --image-uri "${AWS_ECR_IMAGE_URI}" --region=us-east-1 | jq  ## js is a JSON viewer
aws lambda update-function-code --function-name ${LAMBDA_NAME} --image-uri "${AWS_ECR_IMAGE_URI}:${AWS_IMAGE_TAG}" --region=us-east-1

# docker build -t base-aws-php .  #latest
# docker tag ${LOCAL_IMAGE_NAME}:latest ${AWS_ECR_IMAGE_URI}:latest
# docker push ${AWS_ECR_IMAGE_URI}:latest

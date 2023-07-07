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

#####################################################################
## ACTIONS="all" bash ./script.sh
## ACTIONS="tag login" bash ./script.sh
## bash ./script.sh tag login

## build login push tag
ACTIONS=${ACTIONS:-$@}

# if [[ "$ACTIONS" =~ (^| )build($| ) ]] || [[ "$ACTIONS" =~ (^| )all($| ) ]]; then
#   echo "Building..."
#   # build
# fi

if [[ -z $ACTIONS ]]; then
    echo -e "no ACTIONS\n"
    echo -e "Valid ACTIONS values:"
    echo -e "[build login build tag push deploy all quiet]"
    echo -e "
    build ........... Make build of docker image
    login ........... Login on AWS ECR
    tag ............. Create Docker and ECR tag
    push ............ Push Docker image to AWS ECR
    deploy .......... Make deploy on AWS Lambda function
    all ............. Run all actions
    quiet ........... Run action quietly
"
    exit 9;
fi
#####################################################################

QUIET=0
if [[ "$ACTIONS" =~ (^| )quiet($| ) ]]; then
    QUIET=1
fi

LAMBDA_HANDLER_FUNCTION=php-app/lambdaRunnerFile.handler
DATE=$(date +%y%m%d%H%M%S)
PHP_VERSION=8.1
LAMBDA_NAME=SQSTestePHP8
LOCAL_IMAGE_NAME=tiagofranca/base-aws-php
AWS_IMAGE_NAME=base-aws-php
ACCOUNT_ID=029618464094
DATE_IMAGE_TAG="${PHP_VERSION}.${DATE}"
AWS_IMAGE_TAG="${AWS_IMAGE_TAG:-${DATE_IMAGE_TAG}}"
LOCAL_IMAGE_TAG=${LOCAL_IMAGE_TAG:-latest}

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
fi
echo -e "AWS_IMAGE_TAG: ${AWS_IMAGE_TAG}"

if [ -z $LOCAL_IMAGE_TAG ]; then
    echo -e "LOCAL_IMAGE_TAG env is required\n"
    exit 5;
fi
echo -e "LOCAL_IMAGE_TAG: ${LOCAL_IMAGE_TAG}"

#### Define build values
AWS_ECR_URI="${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
AWS_ECR_IMAGE_URI="${AWS_ECR_URI}/${AWS_IMAGE_NAME}"
DOCKER_TAG=${DOCKER_TAG:-latest};
#### END Define build values

## login
if [[ "$ACTIONS" =~ (^| )login($| ) ]] || [[ "$ACTIONS" =~ (^| )all($| ) ]]; then
    echo -e "Login on ECR Docker registry"

    if [ $QUIET -eq 1 ]; then
        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ECR_URI} > /dev/null 2>&1 || echo ''
    else
        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ECR_URI}

        if [ $? -ne 0 ]; then
            echo -e "Fail to login on AWS ECR"
        fi
    fi
fi

## build
if [[ "$ACTIONS" =~ (^| )build($| ) ]] || [[ "$ACTIONS" =~ (^| )all($| ) ]]; then
    echo -e "Building"
    docker build --build-arg LAMBDA_HANDLER_FUNCTION=${LAMBDA_HANDLER_FUNCTION} -t ${LOCAL_IMAGE_NAME}:${LOCAL_IMAGE_TAG} .
fi

## tag
if [[ "$ACTIONS" =~ (^| )tag($| ) ]] || [[ "$ACTIONS" =~ (^| )all($| ) ]]; then
    echo -e "Tagging"
    docker tag ${LOCAL_IMAGE_NAME}:${LOCAL_IMAGE_TAG} ${AWS_ECR_IMAGE_URI}:${AWS_IMAGE_TAG}
fi

## push
if [[ "$ACTIONS" =~ (^| )push($| ) ]] || [[ "$ACTIONS" =~ (^| )all($| ) ]]; then
    echo -e "Pushing"
    docker push ${AWS_ECR_IMAGE_URI}:${AWS_IMAGE_TAG}
fi

## deploy
if [[ "$ACTIONS" =~ (^| )deploy($| ) ]] || [[ "$ACTIONS" =~ (^| )all($| ) ]]; then
    echo -e "Deploying lambda"
    # aws lambda update-function-code --function-name ${LAMBDA_NAME} --image-uri "${AWS_ECR_IMAGE_URI}" --region=us-east-1 | jq  ## js is a JSON viewer

    if [ $QUIET -eq 1 ]; then
        aws lambda update-function-code --function-name ${LAMBDA_NAME} --image-uri "${AWS_ECR_IMAGE_URI}:${AWS_IMAGE_TAG}" --region=us-east-1 > /dev/null 2>&1 || echo ''
    else
        aws lambda update-function-code --function-name ${LAMBDA_NAME} --image-uri "${AWS_ECR_IMAGE_URI}:${AWS_IMAGE_TAG}" --region=us-east-1 | jq
    fi
fi

# docker build -t base-aws-php .  #latest
# docker tag ${LOCAL_IMAGE_NAME}:latest ${AWS_ECR_IMAGE_URI}:latest
# docker push ${AWS_ECR_IMAGE_URI}:latest

ACTIONS="${ACTIONS/quiet/}"
notify-send "End of actions: ${ACTIONS}" -u low -t 500 > /dev/null 2>&1 || echo 'Finished'

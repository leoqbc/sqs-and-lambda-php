AWS_TAG=${AWS_TAG:-latest};

DOCKER_TAG=${DOCKER_TAG:-latest};

## IMAGE_ID=029618464094 bash ./script.sh

if [ -z $IMAGE_ID ]; then
    echo -e "IMAGE_ID env is required\n"
    exit 9;
else
    echo -e "IMAGE_ID: ${IMAGE_ID}"
fi

if [ -z $AWS_TAG ]; then
    echo -e "AWS_TAG env is required\n"
    exit 5;
else
    echo -e "Tag: ${AWS_TAG}"
fi

IMAGE_URI="${IMAGE_ID}.dkr.ecr.us-east-1.amazonaws.com/php8-lambda-runtime-alpine:${AWS_TAG}"

docker build -t php8-lambda-runtime-alpine:${DOCKER_TAG} .
docker tag php8-lambda-runtime-alpine:${DOCKER_TAG} "${IMAGE_URI}"
docker push "${IMAGE_URI}"

## Deploy
aws lambda update-function-code --function-name SQSTestePHP8 --image-uri "${IMAGE_URI}" --region=us-east-1 | jq

notify-send 'build and pushed to AWS ECR' -u low -t 500

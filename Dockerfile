FROM leoqbc/php8-lambda-runtime-alpine:latest

COPY . /var/task

CMD [ "index" ]
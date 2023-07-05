#!/bin/sh

if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
  echo 'if';
  exec /usr/local/bin/aws-lambda-rie /usr/local/bin/php ${LAMBDA_RUNTIME_DIR}/bootstrap $@
else
  echo 'else';
  exec /usr/local/bin/php ${LAMBDA_RUNTIME_DIR}/bootstrap $@
fi

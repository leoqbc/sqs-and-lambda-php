FROM leoqbc/php8-lambda-runtime-alpine:latest

RUN apk add bash curl wget git zsh nano

RUN curl https://getcomposer.org/download/latest-2.2.x/composer.phar -o /usr/bin/composer
RUN chmod +x /usr/bin/composer

COPY . /var/task

RUN COMPOSER_ALLOW_SUPERUSER=1 /usr/bin/composer -vv --working-dir='/var/task' install

CMD [ "index" ]

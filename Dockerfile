FROM public.ecr.aws/lambda/provided:latest

ARG LAMBDA_HANDLER_FUNCTION='handler.helloWorld'
ENV LAMBDA_HANDLER_FUNCTION=${LAMBDA_HANDLER_FUNCTION:-handler.helloWorld}

RUN echo "LAMBDA_HANDLER_FUNCTION: ${LAMBDA_HANDLER_FUNCTION}"

# Defina a versão do PHP que você deseja usar (8.1 no seu caso)
ENV PHP_VERSION=8.1

# Instale as dependências necessárias
RUN yum update -y && \
    yum install -y amazon-linux-extras && \
    amazon-linux-extras enable php$PHP_VERSION && \
    yum clean metadata && \
    yum install -y php-cli php-pear phpize

RUN pecl channel-update pecl.php.net
RUN pecl update-channels

RUN yum install -y bash zsh

## PHP libs, pecl, build and some Laravel dependencies
# COPY ./.docker-data/dependencies-install.sh /tmp/dependencies-install.sh

# RUN bash /tmp/dependencies-install.sh

RUN yum install -y autoconf \
    bison \
    bzip2-devel \
    libzstd libzstd-devel \
    gcc gcc-c++ make cc cmake  zlib zlib-devel cpp \
    libcurl-devel \
    libxml2-devel \
    openssl-devel \
    git gzip tar unzip zip \
    re2c \
    nano \
    zsh \
    uuid \
    sqlite-devel \
    oniguruma-devel

RUN yum install -y php-opcache libuuid-devel uuid-c++ libuuid uuid-devel uuidd
RUN yum install -y gcc gcc10 libcmpiCppImpl0 compat-poppler022-cpp compat-gcc-48
RUN yum install -y cpp cpp10 poppler-cpp poppler-cpp-devel
RUN yum install -y libyaml libyaml-devel

RUN yum install -y php php-cli php-fpm php-devel \
    php-pdo \
    php-pgsql \
    php-bcmath \
    php-bz2 \
    php-common \
    php-curl \
    php-gd \
    php-gmp \
    php-mbstring \
    php-opcache \
    php-pgsql \
    php-pdo_pgsql \
    php-pdo_sqlite \
    php-mysqli \
    php-mysqlnd \
    php-sqlite3 \
    php-xml \
    php-zip \
    php-dom \
    php-intl \
    php-gmp \
    php-simplexml \
    php-sockets \
    php-openssl \
    php-fileinfo \
    php-xmlwriter \
    php-tokenizer \
    php-phar

RUN yes 'no'|pecl install igbinary
RUN yes 'no'|pecl install redis
RUN yes 'no'|pecl install lzf
RUN yes|pecl install memcache
RUN echo ''|pecl install yaml
RUN echo ''|pecl install uuid
RUN pecl install xdebug
RUN pecl install mongodb

## WIP - swoole will is not be installed
# yes|pecl install swoole

COPY ./.docker-data/php/custom-options.ini /etc/php.d/20-custom-options.ini

RUN curl 'https://getcomposer.org/download/latest-2.2.x/composer.phar' -o /usr/bin/composer
RUN chmod +x /usr/bin/composer

COPY ./runtime /var/runtime

RUN chmod +x /var/runtime/bootstrap

# Copie o código da função Lambda para o diretório de trabalho
COPY . /var/task

################################################
### Configurando o handler da função Lambda
# No docker-compose, essa linha vai em 'command:'
# Se nada for informado no 'command', usara o valor definido aqui
#
# TIP: Pode-se usar a seção do Lambda para informar qual função executar
# https://[REGION].console.aws.amazon.com/lambda/home?region=[REGION]#/functions/[FUNCTION NAME]?tab=image
# Ex:
# https://us-east-1.console.aws.amazon.com/lambda/home?region=us-east-1#/functions/SQSTestePHP8?tab=image
#
# Explicando: php-app/lambdaRunnerFile.handler
# php-app/ -> Pasta onde está o arquivo alvo
# lambdaRunnerFile -> arquivo alvo 'lambdaRunnerFile.php'
# handler -> função definida dentro do arquivo alvo

# CMD [ "php-app/lambdaRunnerFile.handler" ]
CMD [ "handler.helloWorld" ]
################################################

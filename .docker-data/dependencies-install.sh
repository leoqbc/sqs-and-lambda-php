#!/usr/bin/env bash

yum install -y autoconf \
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

yum install -y php-opcache libuuid-devel uuid-c++ libuuid uuid-devel uuidd
yum install -y gcc gcc10 libcmpiCppImpl0 compat-poppler022-cpp compat-gcc-48
yum install -y cpp cpp10 poppler-cpp poppler-cpp-devel
yum install -y libyaml libyaml-devel

yum install -y php php-cli php-fpm php-devel \
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

yes 'no'|pecl install igbinary
yes 'no'|pecl install redis
yes 'no'|pecl install lzf
yes|pecl install memcache
echo ''|pecl install yaml
echo ''|pecl install uuid
pecl install xdebug
pecl install mongodb

## WIP - swoole will is not be installed
# yes|pecl install swoole

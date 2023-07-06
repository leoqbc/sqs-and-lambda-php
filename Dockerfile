FROM public.ecr.aws/lambda/provided:latest

ARG LAMBDA_HANDLER_FUNCTION='handler.helloWorld'
ENV LAMBDA_HANDLER_FUNCTION=${LAMBDA_HANDLER_FUNCTION:-'handler.helloWorld'}

# Defina a versão do PHP que você deseja usar (8.1 no seu caso)
ENV PHP_VERSION=8.1

# Instale as dependências necessárias
RUN yum update -y && \
    yum install -y amazon-linux-extras && \
    amazon-linux-extras enable php$PHP_VERSION && \
    yum clean metadata && \
    yum install -y php-cli

COPY ./runtime /var/runtime

RUN chmod +x /var/runtime/bootstrap

# Copie o código da função Lambda para o diretório de trabalho
COPY . /var/task

################################################
### Configurando o handler da função Lambda
# No docker-compose, essa linha vai em 'command:'
# Se nada for informado no 'command', usara o valor definido aqui
# Pode-se usar a seção do Lambda para informar qual função executar
#
# Explicando: php-app/lambdaRunnerFile.handler
# php-app/ -> Pasta onde está o arquivo alvo
# lambdaRunnerFile -> arquivo alvo 'lambdaRunnerFile.php'
# handler -> função definida dentro do arquivo alvo

# CMD [ "php-app/lambdaRunnerFile.handler" ]
# CMD [ "handler.helloWorld" ]
CMD [ ${LAMBDA_HANDLER_FUNCTION} ]
################################################

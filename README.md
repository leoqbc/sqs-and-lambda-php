# Using repo

```sh
## Porta usada localmente para testes
LAMBDA_OFFLINE_LOCAL_PORT=9000

## Função que executará dentro do container
LAMBDA_HANDLER_FUNCTION=handler.helloWorld
```

## Plain function file
```php
// examples/app/index.php

function func(array $event): string
{
    return json_encode([
        'statusCode' => 200, // or other
        'headers' => [
            'any_header' => 'value'
        ],
        'body' => 'Success',
    ]);
}
```

## CMD params

> Se o arquivo for `examples/app/index.php` e a função alvo for `func`, o **CMD** precisa ser `examples/app/index.func`.
>
> Exemplo:

```Dockerfile

CMD [ "examples/app/index.func" ]
```

## Rebuild and deployment via CLI

> **( ! )** First copy `utils/build-and-push-demo.sh` to `utils/build-and-push.sh` and change info.
```sh
bash ./utils/build-and-push.sh
```

### Dockerfile `(aqui que você tem que se atentar quando for subir para o ECR)` se for usar no Lambda

```Dockerfile
# No docker-compose, essa linha vai em 'command:'
# Explicando: php-app/lambdaRunnerFile.handler
# php-app/ -> Pasta onde está o arquivo alvo
# lambdaRunnerFile -> arquivo alvo 'lambdaRunnerFile.php'
# handler -> função definida dentro do arquivo alvo
CMD [ "php-app/lambdaRunnerFile.handler" ]
```

### HTTP requests (demo)

- Se usar o VSCode, instale a extensão `humao.rest-client`
```sh
# VSCode Extension ID: humao.rest-client
@id:humao.rest-client
```

##### HTTP test request with SQS body
```http
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d '{
  "Records": [
    {
      "messageId": "19dd0b57-b21e-4ac1-bd88-01bbb068cb78",
      "receiptHandle": "MessageReceiptHandle",
      "body": "Hello from Lambda test!!",
      "attributes": {
        "ApproximateReceiveCount": "1",
        "SentTimestamp": "1523232000000",
        "SenderId": "123456789012",
        "ApproximateFirstReceiveTimestamp": "1523232000001"
      },
      "messageAttributes": {
        "subject":"Assunto rest client",
        "sleep":4,
        "e":"eeeh"
      },
      "eventSource": "aws:sqs",
      "eventSourceARN": "arn:aws:sqs:us-east-1:123456789012:MyQueue",
      "awsRegion": "us-east-1"
    }
  ]
}'
```

##### Basic test request
```http
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```

# Using repo

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

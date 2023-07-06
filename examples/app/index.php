<?php

declare(strict_types=1);

function func(array $event): string
{
    echo __FILE__ . ':' . __LINE__ . PHP_EOL;
    echo __FUNCTION__ . PHP_EOL;

    return jsonResponse(
        [
            'file' => 'app/index.php',
            '__FILE__' => __FILE__ . ':' . __LINE__,
            '__FUNCTION__' => __FUNCTION__,
            'php_version' => PHP_VERSION,
        ]
    );
}

function jsonResponse(array|string $body, int $status = 200, bool $bodyIsJson = false): string
{
    $bodyIsJson = is_string($body) && $bodyIsJson;

    $headers = [
        'Content-Type' => 'application/json; charset=utf-8',
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Allow-Headers' => 'Content-Type',
        'Access-Control-Allow-Methods' => 'OPTIONS,POST,GET'
    ];

    // Padrão de saída
    return json_encode([
        'statusCode' => $status,
        'headers' => $headers,
        'body' => $bodyIsJson ? json_decode($body) : $body,
    ]);
}

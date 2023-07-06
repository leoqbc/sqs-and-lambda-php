<?php

declare(strict_types=1);

require __DIR__ . '/vendor/autoload.php';

function index(array $event): string
{
    return APIResponse(json_encode($event), 200, true);
}

function APIResponse(string $body, int $status, bool $bodyIsJson = false): string
{
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

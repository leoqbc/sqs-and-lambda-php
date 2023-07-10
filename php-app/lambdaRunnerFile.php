<?php

declare(strict_types=1);

// $laravelPath = __DIR__ . '/../no-commit-old/laravel-app';

require_once __DIR__ . '/../utils/laravel-core.php';

function handler(array $event): string
{
    try {
        echo __FILE__ . ':' . __LINE__ . PHP_EOL;
        echo __FUNCTION__ . PHP_EOL;

        $messageAttributes = $event['Records'][0]['MessageAttributes'] ?? $event['Records'][0]['messageAttributes'] ?? [];
        $perqunteAoGpt = $messageAttributes['perqunte_ao_gpt']['StringValue'] ?? $event['Records'][0]['body'] ?? null;

        $response = \App\Services\OpenAI\Client::sendPrompt((string) $perqunteAoGpt);
        $data = $response->json();
        $gptResponseText = $data['choices'][0]['text'] ?? null;
        $gptResponseText = implode(' ', array_filter(array_map('trim', explode(PHP_EOL, (string) $gptResponseText))));

        $urlToCall = 'http://dev-home.tiagofranca.com:8003/webhooks/incoming';

        $clientResponse = Http::withHeaders([
            'Content-Type' => 'application/json; charset=utf-8',
        ])->asJson()->post($urlToCall, [
            "MessageAttributes" => [
                "status" => [
                    "DataType" => "String",
                    "StringValue" => "success"
                ],
                "user_id_type" => [
                    "DataType" => "String",
                    "StringValue" => "email"
                ],
                "user_id" => [
                    "DataType" => "String",
                    "StringValue" => "ti@compart.com.br"
                ],
                "tenant_id" => [
                    "DataType" => "String",
                    "StringValue" => "catupiry"
                ],
                "messageBody" => [
                    "DataType" => "String",
                    "StringValue" => (string) $gptResponseText,
                ],
                "messageTitle" => [
                    "DataType" => "String",
                    "StringValue" => "Resposta da requisição"
                ],
                // "reportFileUrl" => [
                //     "DataType" => "String",
                //     "StringValue" => "http://google.com#reportFileUrl"
                // ],
                // "exportFileUrl" => [
                //     "DataType" => "String",
                //     "StringValue" => "http://google.com#exportFileUrl"
                // ]
            ]
        ]);
    } catch (\Throwable $th) {
        throw $th;
    }

    return jsonResponse(
        [
            'app_name' => env('APP_NAME'),
            '__FILE__' => __FILE__ . ':' . __LINE__,
            '__FUNCTION__' => __FUNCTION__,
            'clientResponse' => $clientResponse?->json() ?? [],
            'php_version' => PHP_VERSION,
            'perqunteAoGpt' => $perqunteAoGpt,
            'gptResponseText' => $gptResponseText ?? '',
            'messageAttributes' => $messageAttributes,
            'event' => $event,
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

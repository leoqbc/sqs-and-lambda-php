<?php
declare(strict_types=1);

require __DIR__ . '/vendor/autoload.php';

use Mailjet\Client;
use Mailjet\Resources;

function index(array $event): string
{
    $messages = $event['Records'];

    foreach ($messages as $message) {
        sendEmail($message['body']);
    }

    return APIResponse('Success', 200);
}

function sendEmail(string $message): bool
{
    $mailJet = new Client(KEY, SECRET, true, [
        'version' => 'v3.1'
    ]);

    $body = [
        'Messages' => [
            [
                'From' => [
                    'Email' => "email@gmail.com",
                    'Name' => "Você Aqui"
                ],
                'To' => [
                    [
                        'Email' => "destinatario@email.com",
                        'Name' => "Destinatario"
                    ]
                ],
                'Subject' => 'Recuperação de senha',
                'TextPart' => 'Recuperação de senha',
                'HTMLPart' => $message,
                'CustomID' => 'AppGettingStartedTest'
            ]
        ]
    ];

    $response = $mailJet->post(Resources::$Email, ['body' => $body]);

    return $response->success();
}

function APIResponse(string $body, int $status): string
{
    $headers = [
        'Content-Type' => 'application/json',
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Allow-Headers' => 'Content-Type',
        'Access-Control-Allow-Methods' => 'OPTIONS,POST,GET'
    ];

    // Padrão de saída
    return json_encode([
        'statusCode' => $status,
        'headers' => $headers,
        'body' => $body
    ]);
}

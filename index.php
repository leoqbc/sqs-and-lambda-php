<?php
declare(strict_types=1);

require __DIR__ . '/vendor/autoload.php';

use App\Mailer\Mail;
use Mailjet\Client;
use Mailjet\Resources;

function index(array $event): string
{
    logInfo(__FILE__ . ':' . __LINE__);
    logInfo(env());
    $messages = $event['Records'] ?? [];

    $result = [
        'success' => 0,
        'fail' => 0,
    ];

    foreach ($messages as $message) {
        logInfo(__FILE__ . ':' . __LINE__);
        $success = sendEmail($message['body'] ?? '');
        if ($success) {
            $result['success'] = ($result['success'] ?? 0) +1;
        }

        if (!$success) {
            $result['fail'] = ($result['fail'] ?? 0) +1;
        }
    }

    logInfo(__FILE__ . ':' . __LINE__);
    return APIResponse(json_encode($result), 200, true);
}

function sendEmail(string $message): bool
{
    $mail = new Mail();

    $subject = 'Recuperação de senha';
    $mail->setSubject($subject);
    $mail->setBody(<<<PHP
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>{$subject}</title>
        </head>
        <body>
        {$message}
        </body>
        </html>
    PHP
    );

    $response = $mail->send();

    logInfo(__FILE__ . ':' . __LINE__, $response);
    return $response['success'] ?? false;
}

function APIResponse(string $body, int $status, bool $bodyIsJson = false): string
{
    $headers = [
        'Content-Type' => 'application/json; charset=utf-8',
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Allow-Headers' => 'Content-Type',
        'Access-Control-Allow-Methods' => 'OPTIONS,POST,GET'
    ];

    logInfo(__FILE__ . ':' . __LINE__);

    // Padrão de saída
    return json_encode([
        'statusCode' => $status,
        'headers' => $headers,
        'body' => $bodyIsJson ? json_decode($body) : $body,
    ]);
}

<?php

declare(strict_types=1);

require __DIR__ . '/vendor/autoload.php';

use App\Mailer\Mail;
use Mailjet\Client;
use Mailjet\Resources;

function index(array $event): string
{
    $logBaseDir = config('log.base_dir');
    $logFile = "{$logBaseDir}/log-info.log";

    file_put_contents($logFile, ''); // Clear all contents

    logInfo(__FILE__ . ':' . __LINE__);
    logInfo(env());
    $messages = $event['Records'] ?? [];

    $result = [
        'success' => 0,
        'fail' => 0,
    ];

    $getMessageAttributes = fn (string $key, $messageAttributes) => array_dot_get(
        (array) $messageAttributes,
        "messageAttributes.{$key}.stringValue"
    );

    foreach ($messages as $message) {
        logInfo(__FILE__ . ':' . __LINE__);
        $sleep = (string) $getMessageAttributes('sleep', $message);
        $subject = (string) $getMessageAttributes('subject', $message);

        echo sprintf("sleep: %s %s %s %s", ...[
            json_encode($sleep, 64 | 128),
            is_numeric($sleep),
            var_dump($sleep),
            PHP_EOL,
        ]);

        $sleep = is_numeric($sleep) && $sleep > 0 ? (int) $sleep : 0;

        if ($sleep) {
            echo "sleeping {$sleep} seconds" . PHP_EOL;
            sleep((int) $sleep);
        }

        $body = $message['body'] ?? '';
        $body = var_export($body, true) . PHP_EOL. "{$sleep} - {$subject}";
        echo $body . PHP_EOL;

        $success = sendEmail($body, $subject);
        $result['messageAttributes'][] = $message['messageAttributes'] ?? [];

        if ($success) {
            $result['success'] = ($result['success'] ?? 0) + 1;
        }

        if (!$success) {
            $result['fail'] = ($result['fail'] ?? 0) + 1;
        }
    }

    logInfo(__FILE__ . ':' . __LINE__);

    $result['log'] = file_get_contents($logFile);
    return APIResponse(json_encode($result), 200, true);
}

function sendEmail(string $message, ?string $subject = null): bool
{
    $mail = new Mail();

    $subject = $subject ?: 'Recuperação de senha';
    $subject = trim(trim($subject, '\''));
    $message = trim(trim($message, '\''));
    $mail->setSubject($subject);
    $mail->setBody(
        <<<PHP
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

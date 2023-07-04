<?php

return [
    'mail_jet' => [
        'key' => env('mail_jet_key'),
        'secret' => env('mail_jet_secret'),
    ],

    'php_mailer' => [
        'Host' => env('PHP_MAILER_HOST'),
        'SMTPAuth' => env('PHP_MAILER_SMTP_AUTH'),
        'Port' => env('PHP_MAILER_PORT'),
        'Username' => env('PHP_MAILER_USERNAME'),
        'Password' => env('PHP_MAILER_PASSWORD'),
    ],
    'log' => [
        'base_dir' => env('LOG_BASE_DIR', __DIR__ . '/logs/'),
    ]
];

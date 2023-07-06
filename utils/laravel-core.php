<?php

declare(strict_types=1);

error_reporting(E_ALL);
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 1);

/**
 * -------- START LARAVEL OUTSIDE ---------
 *
 * To use Laravel core without then
 * If you whant to use core by CLI without artisan
 *
 * $laravelPath = __DIR__ . '/../no-commit-old/laravel-app';
 * require_once __DIR__ . '/../utils/laravel-core.php';
 */

$laravelPath = $laravelPath ?? __DIR__ . '/../laravel-app';

require_once "{$laravelPath}/vendor/autoload.php"; //Full path to file maybe need to change
$app = require_once "{$laravelPath}/bootstrap/app.php"; //Full path to file maybe need to change

$app->make(\Illuminate\Contracts\Console\Kernel::class)->bootstrap();

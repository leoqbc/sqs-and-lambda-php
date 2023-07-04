<?php

define('BASE_PATH', __DIR__);

$bootCheck = [
    ['file_exists', __DIR__ . '/config.php'],
    ['file_exists', __DIR__ . '/env.php'],
    ['file_exists', __DIR__ . '/functions/utils.php'],
];

$errors = [
    'file_exists' => fn($file) => throw new \Exception("Fail: [{$file}] not exists", 1),
];

foreach ($bootCheck as $toCheck) {
    $callable = $toCheck[0] ?? null;
    $params = (array) ($toCheck[1] ?? []);

    if (!in_array($callable, array_keys($errors), true) || !is_callable($callable)) {
        continue;
    }

    if (!call_user_func($callable, ...$params)) {
        if (is_a($errors[$callable], Closure::class)) {
            $errors[$callable]($toCheck);
            continue;
        }
    }
}

$requiredFiles = [
    __DIR__ . '/functions/utils.php',
];

foreach ($requiredFiles as $file) {
    require_once $file;
}

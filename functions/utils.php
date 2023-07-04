<?php

if (!function_exists('array_dot_get')) {
    /**
     * function array_dot_get
     *
     * @param array $array
     * @param string $dotNotation
     *
     * @return mixed
     */
    function array_dot_get(array $array, string $dotNotation): mixed
    {
        foreach (explode('.', $dotNotation) as $key) {
            if (!array_key_exists($key, $array)) {
                return null;
            }

            $array = $array[$key] ?? null;
        }

        return $array;
    }
}

if (!function_exists('env')) {
    /**
     * function env
     *
     * @param string $key
     * @param mixed $defaultValue
     *
     * @return mixed
     */
    function env(string $key = '', mixed $defaultValue = null): mixed
    {
        $env = require BASE_PATH . '/env.php';
        $env = array_merge($env, ($_SERVER ?? []));

        if (!$key) {
            return $env;
        }

        return array_dot_get($env, $key) ?? $defaultValue ?? null;
    }
}

if (!function_exists('config')) {
    /**
     * function config
     *
     * @param string $key
     * @param mixed $defaultValue
     *
     * @return mixed
     */
    function config(string $key = '', mixed $defaultValue = null): mixed
    {
        $config = require BASE_PATH . '/config.php';

        if (!$key) {
            return $config;
        }

        return array_dot_get($config, $key) ?? $defaultValue ?? null;
    }
}

if (!function_exists('logInfo')) {
    /**
     * function logInfo
     *
     * @param ...$content
     *
     * @return void
     */
    function logInfo(...$content): void
    {
        $logContent = [
            PHP_EOL,
            '[',
            date('c'),
            ']',
            '[',
            'info',
            ']',
            ':',
            PHP_EOL,
            json_encode($content, 64|128),
            PHP_EOL,
        ];

        $logBaseDir = config('log.base_dir');

        $logFile = "{$logBaseDir}/log-info.log";

        file_put_contents($logFile, $logContent, FILE_APPEND);
    }
}

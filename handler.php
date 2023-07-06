<?php

function helloWorld(array $event)
{
    return json_encode(
        [
            'body' => 'Hello World',
            'date' => date('c'),
        ]
    );
}

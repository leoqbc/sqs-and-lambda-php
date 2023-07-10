<?php

namespace App\Services\OpenAI;

use Illuminate\Support\Facades\Http;

class Client
{
    /**
     * function sendPrompt
     *
     * @return \Illuminate\Http\Client\Response
     */
    public static function sendPrompt(string $prompt, ?string $model = null): \Illuminate\Http\Client\Response
    {
        $url = 'https://api.openai.com/v1/completions';
        $body = [
            'model' => $model ?? "text-davinci-003",
            'prompt' => $prompt,
            'temperature' => 0.9,
            'max_tokens' => 150,
            'top_p' => 1,
            'frequency_penalty' => 0.0,
            'presence_penalty' => 0.6,
            'stop' => [" Human:", " AI:"]
        ];

        $openaiApiKey = config('services.openai.api_key');

        if (!$openaiApiKey || !is_string($openaiApiKey)) {
            throw new \Exception("OpenAI ApiKey is required", 1);
        }

        $response = Http::withHeaders([
            'Authorization' => "Bearer {$openaiApiKey}",
        ])->asJson()->post($url, $body);

        return $response;
    }
}

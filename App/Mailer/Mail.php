<?php

namespace App\Mailer;

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

class Mail
{
    protected PHPMailer $phpmailer;

    public function __construct()
    {
        $this->initSetup();
    }

    protected function initSetup()
    {
        $this->phpmailer = new PHPMailer();
        $this->phpmailer->setLanguage('pt_br');
        $this->phpmailer->isSMTP();
        $this->phpmailer->Host = config('php_mailer.Host');
        $this->phpmailer->SMTPAuth = config('php_mailer.SMTPAuth');
        $this->phpmailer->Port = config('php_mailer.Port');
        $this->phpmailer->Username = config('php_mailer.Username');
        $this->phpmailer->Password = config('php_mailer.Password');
        $this->phpmailer->isHTML(true);
        $this->phpmailer->CharSet = 'UTF-8';
    }

    /**
     * function setSubject
     *
     * @param string $subject
     *
     * @return static
     */
    public function setSubject(string $subject): static
    {
        $this->phpmailer->Subject = $subject;

        return $this;
    }

    /**
     * function setBody
     *
     * @param string $body
     *
     * @return static
     */
    public function setBody(string $body): static
    {
        $this->phpmailer->Body = $body;
        $this->phpmailer->AltBody = strip_tags($body);

        return $this;
    }

    /**
     * function send
     *
     * @return array
     */
    public function send(): array
    {
        try {
            //Recipients
            $this->phpmailer->setFrom('from@example.com', 'Mailer');
            $this->phpmailer->addAddress('joe@example.net', 'Joe User');     //Add a recipient
            $this->phpmailer->addAddress('ellen@example.com');               //Name is optional
            $this->phpmailer->addReplyTo('info@example.com', 'Information');
            $this->phpmailer->addCC('cc@example.com');
            $this->phpmailer->addBCC('bcc@example.com');

            //Attachments
            // $this->phpmailer->addAttachment('/var/tmp/file.tar.gz');         //Add attachments
            // $this->phpmailer->addAttachment('/tmp/image.jpg', 'new.jpg');    //Optional name

            $this->phpmailer->send();
            return [
                'success' => true,
                'message' => 'Message has been sent',
            ];
        } catch (Exception $e) {
            logInfo($this->phpmailer->ErrorInfo, $e->getMessage());

            if (config('debug')) {
                throw $e;
            }

            return [
                'success' => false,
                'message' => $e->getMessage(),
            ];
        }
    }
}

# tilda-cipher-mail
tilda-cipher-mail service

### Конфигурация
- Текст e-mail сообщения: /etc/tilda-cipher-mail/tilda-cipher-mail.msg
- Сертификат Крипто Про:  /opt/tilda-cipher-mail/job.sh, переменная CERTFILE
- Адрес для отпраки писем: /opt/tilda-cipher-mail/job.sh, переменная EMAIL_TO

[в GitHub серификат полученный в тестовом удостоверяющем центре https://cryptopro.ru/certsrv/]

### Tilda webhook для приема данных из форм
Сделан по требованиям https://help-ru.tilda.cc/forms/webhook 

URL: https://1295435-cb87573.tw1.ru/tilda-webhook.php

Пример вызова:
```
 curl https://1295435-cb87573.tw1.ru/tilda-webhook.php                 \
      -H "Content-Type: application/x-www-form-urlencoded"             \
      -d "param1=value1&param2=value2"                                 \
      -v
```
Webhook требует SSL сертификата. Сейчас в NGINX использутся сертифкат "Let's encrypt" (https://letsencrypt.org/) ограниченного доверия и со сроком действия 3 месяца.
Рекомендуется заменить.

### Периодическая шифровка данных и отправка e-mail через сrontab
Например, каждые 15 минут
```
*/15 * * * *  /opt/tilda-cipher-mail/job.sh
```

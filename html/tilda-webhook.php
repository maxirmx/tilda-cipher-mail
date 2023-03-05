<?php

 header('Access-Control-Allow-Origin: *');

 $headers = "From: tilda-cipher-mail@samsonov.net";
 $message = print_r($_GET,true);
 @mail('maxim@samsonov.net', 'Tilda TEST', $message, $headers);

 echo "ok";

?>

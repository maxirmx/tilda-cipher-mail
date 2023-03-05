<?php
/**
 * tilda-cipher-mail service
 *
 * Tilda callback
 *
 * @author  Максим Самсонов <maxim@samsonov.net>
 * @copyright  2023 Максим Самсонов, его родственники и знакомые
 * @license    http://www.opensource.org/license/mit-0 MIT
 */

 define("SERVICENAME", "tilda-cipher-mail");
 define("DATAFILE",    "/var/".SERVICENAME."/data.txt");

 header("Access-Control-Allow-Origin: *");

 $_SERVER["REQUEST_METHOD"] === "POST" or die("POST method was expected, got ".$_SERVER["REQUEST_METHOD"]);

 $data = print_r(json_encode($_POST, JSON_FORCE_OBJECT), true).PHP_EOL;
 file_put_contents(DATAFILE, $data , FILE_APPEND | LOCK_EX) or die("Unable to append to file ".DATAFILE);

 // [Send debug message when the data is received from tilda]
 // $headers = "From: tilda-cipher-mail <tilda-cipher-mail@1295435-cb87573.tw1.ru>";
 // @mail("your@email.net", "Tilda TEST", $data, $headers);

 echo "ok";
?>

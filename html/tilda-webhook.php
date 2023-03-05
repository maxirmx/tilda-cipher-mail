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

 $headers = "From: tilda-cipher-mail@samsonov.net";

 @mail('maxim@samsonov.net', 'Tilda TEST', $data, $headers);

 echo "ok";
?>

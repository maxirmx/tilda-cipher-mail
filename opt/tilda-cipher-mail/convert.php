#!/usr/bin/php
<?php
  error_reporting(E_ERROR | E_PARSE);
  $out = fopen('/var/tilda/cipher/mail/data.csv', 'w');
  if ($argc<3) {
   die("Fatal: in and out file names expected" . PHP_EOL);
  }

  $out = fopen($argv[2], "w");
  if ($out === false) {
    die("Cannot open output file '". $argv[2] . "'" . PHP_EOL);
  }

  $json=file_get_contents($argv[1]);
  if ($json===false) {
   echo PHP_EOL;
  }
  else {
    $data = json_decode($json);
    $k = array_keys((array)$data[0]);
    fwrite($out, implode("$", $k) . PHP_EOL);
    foreach($data as $d){
      $s = implode("$", (array)$d);
      $s = str_replace("\n", "", $s);
      $s = str_replace("\r", "", $s);
      fwrite ($out, $s . PHP_EOL);
    }
  }
  fclose($out);
?>

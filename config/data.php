<?php

  // LOCAL
  // $user_par = 'postgres';
  // $password_par = 'postgres';
  // $databaseName_par = 'grupo90e3';
  // $user_impar = 'postgres';
  // $password_impar = 'postgres';
  // $databaseName_impar = 'grupo95e3';

  // HEROKU DB1

  $db1 = parse_url(getenv("DATABASE_URL"));
  $host1 = $db1["host"];
  $port1 = $db1["port"];
  $user1 = $db1["user"];
  $password1 = $db1["pass"];
  $database1 = ltrim($db1["path"], "/");


  // HEROKU DB2

  $db2 = parse_url(getenv("HEROKU_POSTGRESQL_CHARCOAL_URL"));
  $host2 = $db1["host"];
  $port2 = $db1["port"];
  $user2 = $db1["user"];
  $password2 = $db1["pass"];
  $database2 = ltrim($db1["path"], "/");


?>
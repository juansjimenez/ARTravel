<?php
   // LOCAL 
  // try {
  //  #Pide las variables para conectarse a la base de datos.
  //  require('data.php');
  //  # Se crea la instancia de PDO
  //  $db_par = new PDO("pgsql:dbname=$databaseName_par;host=localhost;user=$user_par;password=$password_par");
  //  $db_impar = new PDO("pgsql:dbname=$databaseName_impar;host=localhost;user=$user_impar;password=$password_impar");
  // } catch (Exception $e) {
  //  echo "No se pudo conectar a la base de datos: $e";
  // }

  // HEROKU
  try {
    #Pide las variables para conectarse a la base de datos.
    require('data.php');
    # Se crea la instancia de PDO
    $db_par = new PDO("pgsql:dbname=$database1;host=$host1;port=$port1;user=$user1;password=$password1");
    $db_impar = new PDO("pgsql:dbname=$database2;host=$host2;port=$port2;user=$user2;password=$password2");
   } catch (Exception $e) {
    echo "No se pudo conectar a la base de datos: $e";
   }



?>

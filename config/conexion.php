<?php
  try {
   #Pide las variables para conectarse a la base de datos.
   require('data.php');
   # Se crea la instancia de PDO
   $db_par = new PDO("pgsql:dbname=$databaseName_par;host=localhost;user=$user_par;password=$password_par");
   $db_impar = new PDO("pgsql:dbname=$databaseName_impar;host=localhost;user=$user_impar;password=$password_impar");
  } catch (Exception $e) {
   echo "No se pudo conectar a la base de datos: $e";
  }

?>

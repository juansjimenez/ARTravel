<?php session_start();?>
<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>ARTravel</title>

  <!-- Bootstrap core CSS -->
  <link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom fonts for this template -->
  <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="../css/one-page-wonder.min.css" rel="stylesheet">

  <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

  <link rel="shortcut icon" href="../img/favicon.ico">

</head>

<body>
  <!-- Navigation -->
  <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container">
      <a class="navbar-brand" href="../index.php">Home</a>
      <a class="navbar-brand" href="artistas.php">Artistas</a>
      <a class="navbar-brand" href="obras.php">Obras</a>
      <a class="navbar-brand" href="lugares.php">Lugares</a>
      <a class="navbar-brand" href="hoteles.php">Hoteles</a>
      <a class="navbar-brand" href="ticket_transporte.php">Tickets de Transporte </a>
      <a class="navbar-brand" href="generate_itinerary.php"> Itinerarios </a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <?php include("../templates/dropdown_perfil.html"); ?>

  <header class="masthead text-center text-white">
    <div class="masthead-content">
      <div class="container">
        <h1 class="masthead-heading mb-0">Perfil de <?php echo $_SESSION["username"]?></h1>
          <?php
            require("../config/conexion.php");

            $sql = "SELECT * FROM usuarios WHERE username = :username";

            if($stmt = $db_impar->prepare($sql)){
            // Bind variables to the prepared statement as parameters
            $stmt->bindParam(":username", $param_username, PDO::PARAM_STR);

            // Set parameters
            $param_username = trim($_SESSION["username"]);
                // Attempt to execute the prepared statement
                if($stmt->execute()){
                    $data = $stmt -> fetch();
                    echo "<h5>Nombre: {$data['nombre']}</h5>";
                    echo "<h5>Correo: {$data['correo']}</h5>";
                    echo "<h5>Direccion: {$data['direccion']}</h5>";

                } else{
                    echo "Oops! Something went wrong. Please try again later.";
                }

                // Close statement
                unset($stmt);
            }
            $dinero_gastado = 0;
            $sql = "SELECT m.precio_entrada FROM museos AS m, entradas_museos AS e WHERE m.lid = e.lid AND e.uid = :user_id";
            if($stmt = $db_par->prepare($sql)){
              $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);
              $param_user_id = $_SESSION["id"];
              if($stmt->execute()){
                    $data = $stmt -> fetchAll();
                    foreach ($data as $p){
                      $dinero_gastado = $dinero_gastado + $p['precio_entrada'];
                    }
                } else{
                    echo "Oops! Something went wrong. Please try again later.";
                }
                unset($stmt);
            }
            $sql = " SELECT h.precio*(r.fecha_salida-r.fecha_llegada) AS dinero FROM reservas AS r, hoteles AS h WHERE r.id_hotel = h.id_hotel AND r.usuario_id = :user_id";
            if($stmt = $db_impar->prepare($sql)){
              $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);
              $param_user_id = $_SESSION["id"];
              if($stmt->execute()){
                    $data = $stmt -> fetchAll();
                    foreach ($data as $p){
                      $dinero_gastado = $dinero_gastado + $p['dinero'];
                    }
                } else{
                    echo "Oops! Something went wrong. Please try again later.";
                }
                unset($stmt);
            }$sql = " SELECT SUM(h.precio*(r.fecha_salida-r.fecha_llegada)) AS dinero FROM reservas as r, hoteles as h WHERE r.id_hotel = h.id_hotel AND r.usuario_id = :user_id GROUP BY r.usuario_id";
            if($stmt = $db_impar->prepare($sql)){
              $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);
              $param_user_id = $_SESSION["id"];
              if($stmt->execute()){
                    $data = $stmt -> fetch();
                    $dinero_gastado = $dinero_gastado + $data['dinero'];
                } else{
                    echo "Oops! Something went wrong. Please try again later.";
                }
                unset($stmt);
            }
            $sql = " SELECT SUM(h.precio*(r.fecha_salida-r.fecha_llegada)) AS dinero FROM reservas as r, hoteles as h WHERE r.id_hotel = h.id_hotel AND r.usuario_id = :user_id GROUP BY r.usuario_id";
            if($stmt = $db_impar->prepare($sql)){
              $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);
              $param_user_id = $_SESSION["id"];
              if($stmt->execute()){
                    $data = $stmt -> fetch();
                    $dinero_gastado = $dinero_gastado + $data['dinero'];
                } else{
                    echo "Oops! Something went wrong. Please try again later.";
                }
                unset($stmt);
            }
            if ($dinero_gastado > 0){
              echo "<h5>Dinero gastado: {$dinero_gastado}</h5>";
            } else{
              echo "<h5>Dinero gastado: {$dinero_gastado}, Que esperas para comenzar a viajar!</h5>";
            }
        ?>
        <a href="#entradas_museos" class="btn btn-primary btn-xl rounded-pill mt-5">Entradas Museos</a>
        <a href="#reserva_hotel" class="btn btn-primary btn-xl rounded-pill mt-5">Reservas Hoteles</a>
        <a href="#tickets_transporte" class="btn btn-primary btn-xl rounded-pill mt-5">Tickets Viajes</a>
        <a href="./destroy_account.php" class="btn btn-primary btn-xl rounded-pill mt-5">Eliminar cuenta</a>
      </div>
    </div>
  </header>

  <section id="entradas_museos">
    <div>
      <div class="row align-items-center">
        <div class="col-lg-6 order-lg-2">
          <div class="p-5" data-aos="fade-left" data-aos-delay="100">
            <?php
            require("../config/conexion.php");
            $sql = "select c.nombre, c.hora_apertura, c.hora_cierre, fecha_compra from entradas_museos, (select m.lid, m.hora_apertura, m.hora_cierre, l.nombre from museos as m, lugares as l where m.lid = l.lid) as c where c.lid = entradas_museos.lid and entradas_museos.uid = :user_id";

            if($stmt = $db_par->prepare($sql)){
            // Bind variables to the prepared statement as parameters
            $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);

            // Set parameters
            $param_user_id = $_SESSION["id"];

            // Attempt to execute the prepared statement
            if($stmt->execute()){
                if($stmt->rowCount() < 1){
                    echo "<p class='display-4'>No se han encontrado entradas</p>\n";
                } else{
                    $entradas_museos = $stmt->fetchAll();
                    echo "<table class='container'>\n";
                      echo "<tr>";
                      echo "<th>Nombre museo</th>";
                      echo "<th>Horario apertura</th>";
                      echo "<th>Horario clausura</th>";
                      echo "<th>Fecha compra</th>";
                      echo "</tr>";
                    foreach ($entradas_museos as $p) {
                      echo "<tr><td>$p[0]</td><td>$p[1]</td><td>$p[2]</td><td>$p[3]</td></tr>";
                    }
                    echo "</table>";
                }
              } else{
                echo "Oops! Something went wrong. Please try again later.";
              }
              // Close statement
              unset($stmt);
            }
            ?>
          </div>
        </div>
        <div class="col-lg-6 order-lg-1">
          <div class="p-5" data-aos="fade-right" data-aos-delay="100">
            <h2 class="display-4">Entradas a Museos:</h2>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section id="reserva_hotel">
    <div >
      <div class="row align-items-center">
        <div class="col-lg-6">
          <div class="p-5" data-aos="fade-left" data-aos-delay="100">
            <?php
            require("../config/conexion.php");
            $sql = "SELECT h.direccion, r.fecha_llegada, r.fecha_salida FROM reservas AS r, (SELECT id_hotel, direccion FROM hoteles) AS h WHERE r.id_hotel = h.id_hotel AND r.usuario_id = :user_id";

            if($stmt = $db_impar->prepare($sql)){
            // Bind variables to the prepared statement as parameters
            $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);

            // Set parameters
            $param_user_id = $_SESSION["id"];

            // Attempt to execute the prepared statement
            if($stmt->execute()){
                if($stmt->rowCount() < 1){
                    echo "<p class='display-4'>No se han encontrado reservas</p>\n";
                } else{
                    $reservas_usuario = $stmt->fetchAll();
                    echo "<table class='container'>\n";
                      echo "<tr>";
                      echo "<th>Fecha Llegada</th>";
                      echo "<th>Fecha Salida</th>";
                      echo "<th>Direccion Hotel</th>";
                      echo "</tr>";
                    foreach ($reservas_usuario as $p) {
                      echo "<tr><td>$p[1]</td><td>$p[2]</td><td>$p[0]</td></tr>";
                    }
                    echo "</table>";
                }
              } else{
                echo "Oops! Something went wrong. Please try again later.";
              }
              // Close statement
              unset($stmt);
            }
            ?>
          </div>
        </div>
        <div class="col-lg-6">
          <div class="p-5" data-aos="fade-right" data-aos-delay="100">
            <h2 class="display-4">:Reservas de Hoteles</h2>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section id="tickets_transporte">
    <div>
      <div class="row align-items-center">
        <div class="col-lg-6 order-lg-2">
          <div class="p-5" data-aos="fade-left" data-aos-delay="100">
            <?php
            require("../config/conexion.php");
            $sql = "select numero_de_asiento, t.fecha_compra, t.fecha_viaje, ciudad_origen, ciudad_destino from tickets as t, (select id_viaje, a.cnombre as ciudad_origen, b.cnombre as ciudad_destino from viajes, ciudades as a, ciudades as b where a.id_ciudad = id_ciudad_origen and b.id_ciudad= id_ciudad_destino) as c where c.id_viaje = t.id_viaje and usuario_id = :user_id;";

            if($stmt = $db_impar->prepare($sql)){
            // Bind variables to the prepared statement as parameters
            $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);

            // Set parameters
            $param_user_id = $_SESSION["id"];

            // Attempt to execute the prepared statement
            if($stmt->execute()){
                if($stmt->rowCount() < 1){
                    echo "<p class='display-4'>No se han encontrado tickets</p>\n";
                } else{
                    $tickets_usuario = $stmt->fetchAll();
                    echo "<table class='container'>\n";
                      echo "<tr>";
                      echo "<th>Numero asiento</th>";
                      echo "<th>Fecha de compra</th>";
                      echo "<th>fecha de salida</th>";
                      echo "<th>ciudad origen</th>";
                      echo "<th>ciudad destino</th>";
                      echo "</tr>";
                    foreach ($tickets_usuario as $p) {
                      echo "<tr><td>$p[0]</td><td>$p[1]</td><td>$p[2]</td><td>$p[3]</td><td>$p[4]</td></tr>";
                    }
                    echo "</table>";
                }
            } else{
              print_r($stmt->errorInfo());
              echo "Oops! Something went wrong. Please try again later.";
            }
              // Close statement
              unset($stmt);
            }
            ?>
          </div>
        </div>
        <div class="col-lg-6 order-lg-1">
          <div class="p-5" data-aos="fade-right" data-aos-delay="100">
            <h2 class="display-4">Tickets de transporte:</h2>
          </div>
        </div>
      </div>
    </div>
  </section>


  <!-- Footer -->
  <footer class="py-5 bg-black">
    <div class="container">
      <p class="m-0 text-center text-white small"></p>
    </div>
    <!-- /.container -->
  </footer>

  <!-- Bootstrap core JavaScript -->
  <script src="../jquery/jquery.min.js"></script>
  <script src="../bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="https://unpkg.com/aos@next/dist/aos.js"></script>
  <script>
    AOS.init();
  </script>
</body>

</html>

<?php session_start(); ?>
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

  <link href="../css/imagenes.css" rel="stylesheet">
  <style>
    #leftbox {
        float:center;
        /* width:68%; */
        height:155px;
    }

    #leftbox2{
        float:center;
        /* width:96%; */
        height:155px;

    }
  </style>

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
    <div id="leftbox">
        <?php
            require("../config/conexion.php");
            // Prepare a select statement
            $foto = "SELECT url, nombre FROM artistas a WHERE a.aid = :aid";

            if($stmt = $db_par->prepare($foto)){
                // Bind variables to the prepared statement as parameters
                $stmt->bindParam(":aid", $param_aid, PDO::PARAM_STR);
                // Set parameters
                $param_aid = $_GET['id'];
                // Attempt to execute the prepared statement
                if($stmt->execute()){
                    $data = $stmt -> fetchall();

                    echo "<img src={$data[0][0]} class='resize2'/>";


                } else{
                    echo "Oops! Something went wrong. Please try again later.";
                }
                // Close statement
                unset($stmt);
              }

        ?>

    </div>
    <div id="leftbox2">
        <?php
            echo "<h1 style=font-size:100px>{$data[0][1]}</h1>";
        ?>
    </div>
  </header>


  <section>
    <div class="container">
            <div class="p-5" data-aos="fade-right" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Artista</h1>
                </div>
                <?php
                    require("../config/conexion.php");
                    // Prepare a select statement
                    $fallecido = "SELECT aid, fecha_fallecimiento FROM artistas_fallecidos WHERE aid = :aid";

                    if ($stmt_1 = $db_par->prepare($fallecido)) {
                        // Bind variables to the prepared statement as parameters
                        $stmt_1->bindParam(":aid", $param_aid_f, PDO::PARAM_STR);
                        // Set parameters
                        $param_aid_f = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt_1->execute()){
                            if($stmt_1->rowCount() >= 1){
                                $data_f = $stmt_1 -> fetchall();
                                $sql = "SELECT * FROM artistas WHERE aid = :aid";
                                if($stmt = $db_par->prepare($sql)){
                                    // Bind variables to the prepared statement as parameters
                                    $stmt->bindParam(":aid", $param_aid, PDO::PARAM_STR);
                                    // Set parameters
                                    $param_aid = $_GET['id'];
                                    // Attempt to execute the prepared statement
                                    if($stmt->execute()){
                                        $data = $stmt -> fetchall();
                                        echo "<p  style=font-size:25px> <strong>Fecha nacimiento:</strong> {$data[0][2]}</p>";
                                        echo "<p  style=font-size:25px> <strong>Fecha fallecimiento:</strong> {$data_f[0][1]}</p>";
                                        echo "<p  style=font-size:25px> <strong>Descripción:</strong> {$data[0][3]}</p>";

                                    } else{
                                        echo "Oops! Something went wrong. Please try again later.";
                                    }
                                    // Close statement
                                    unset($stmt);
                                }
                            }else {
                                $data_f = $stmt_1 -> fetchall();
                                $sql = "SELECT * FROM artistas WHERE aid = :aid";
                                if($stmt = $db_par->prepare($sql)){
                                    // Bind variables to the prepared statement as parameters
                                    $stmt->bindParam(":aid", $param_aid, PDO::PARAM_STR);
                                    // Set parameters
                                    $param_aid = $_GET['id'];
                                    // Attempt to execute the prepared statement
                                    if($stmt->execute()){
                                        $data = $stmt -> fetchall();
                                        echo "<p  style=font-size:25px> <strong>Nombre:</strong> {$data[0][1]}</p>";
                                        echo "<p  style=font-size:25px> <strong>Fecha nacimiento:</strong> {$data[0][2]}</p>";
                                        echo "<p  style=font-size:25px> <strong>Descripción:</strong> {$data[0][3]}</p>";
                                    } else{
                                        echo "Oops! Something went wrong. Please try again later.";
                                    }
                                    // Close statement
                                    unset($stmt);
                                }
                            }
                        }
                        unset($stmt_1);
                    }

                ?>
          </div>
    </div>
  </section>
  <section>
    <div class="container">
      <div>
            <div class="p-5" data-aos="fade-left" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Obras </h1>
                </div>
                <?php
                    require("../config/conexion.php");
                    // Prepare a select statement
                    $sql = "SELECT DISTINCT obras.oid, obras.nombre, fecha_inicio, fecha_culminacion, periodo FROM obras, hecha_por WHERE obras.oid  = hecha_por.oid AND hecha_por.aid = :aid";

                    if($stmt = $db_par->prepare($sql)){
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":aid", $param_aid, PDO::PARAM_STR);

                        // Set parameters
                        $param_aid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            $data = $stmt -> fetchall();
                            echo "<table class='container'>";
                              echo "<tr>";
                              echo "<th h1 style=font-size:25px>Nombre</th>";
                              echo "<th h1 style=font-size:25px>Año inicio</th>";
                              echo "<th h1 style=font-size:25px>Año culminacion</th>";
                              echo "<th h1 style=font-size:25px>Periodo</th>";
                              echo "<th h1 style=font-size:25px>Tipo</th>";
                              echo "</tr>";
                            foreach ($data as $p) {
                                $esculturas = "SELECT material FROM esculturas WHERE oid  = :oid";
                                $pinturas = "SELECT tecnica FROM pinturas  WHERE oid = :oid";
                                $frescos = "SELECT * FROM frescos WHERE oid = :oid";

                                if ($stmt_1 = $db_par->prepare($esculturas)) {
                                    // Bind variables to the prepared statement as parameters
                                    $stmt_1->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                                    // Set parameters
                                    $param_oid = $p[0];
                                    // Attempt to execute the prepared statement
                                    if($stmt_1->execute()){
                                        if($stmt_1->rowCount() >= 1){
                                            echo "<tr h1 style=font-size:25px><td><a href='info_obras.php?id=$p[0]'>$p[1]</a></td><td>$p[2]</td><td>$p[3]</td><td>$p[4]</td><td>Escultura</td></tr>";
                                        }
                                    }
                                    unset($stmt_1);
                                }

                                if ($stmt_1 = $db_par->prepare($pinturas)) {
                                    // Bind variables to the prepared statement as parameters
                                    $stmt_1->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                                    // Set parameters
                                    $param_oid = $p[0];
                                    // Attempt to execute the prepared statement
                                    if($stmt_1->execute()){
                                        if($stmt_1->rowCount() >= 1){
                                            echo "<tr h1 style=font-size:25px><td><a href='info_obras.php?id=$p[0]'>$p[1]</a></td><td>$p[2]</td><td>$p[3]</td><td>$p[4]</td><td>Pintura</td></tr>";
                                        }
                                    }
                                    unset($stmt_1);
                                }

                                if ($stmt_1 = $db_par->prepare($frescos)) {
                                    // Bind variables to the prepared statement as parameters
                                    $stmt_1->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                                    // Set parameters
                                    $param_oid = $p[0];
                                    // Attempt to execute the prepared statement
                                    if($stmt_1->execute()){
                                        if($stmt_1->rowCount() >= 1){
                                            echo "<tr h1 style=font-size:25px><td><a href='info_obras.php?id=$p[0]'>$p[1]</a></td><td>$p[2]</td><td>$p[3]</td><td>$p[4]</td><td>Fresco</td></tr>";
                                        }
                                    }
                                    unset($stmt_1);
                                }


                            }
                            echo "</table>";
                        } else{
                            echo "Oops! Something went wrong. Please try again later.";
                        }
                        // Close statement
                        unset($stmt);
                    }


                ?>
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

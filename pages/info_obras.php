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
            $foto = "SELECT url, o.nombre FROM obras o, fotos_obras fo WHERE o.oid = fo.oid AND o.oid = :oid";

            if($stmt = $db_par->prepare($foto)){
                // Bind variables to the prepared statement as parameters
                $stmt->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                // Set parameters
                $param_oid = $_GET['id'];
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
                    <h1 style=font-size:45px>Obra</h1>
                </div>
                <?php
                    require("../config/conexion.php");
                    // Prepare a select statement
                    $sql = "SELECT DISTINCT artistas.aid, artistas.nombre, obras.oid, obras.nombre, fecha_inicio, fecha_culminacion,
                    periodo FROM artistas, obras, hecha_por WHERE obras.oid = hecha_por.oid AND artistas.aid = hecha_por.aid
                     AND obras.oid = :oid";

                    if($stmt = $db_par->prepare($sql)){
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                        // Set parameters
                        $param_oid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            $data = $stmt -> fetchall();
                            echo "<table class='container'>\n";
                              echo "<th style=font-size:25px>Artista(s):</th>";
                              echo "</tr>";
                            foreach ($data as $p) {
                              echo "<tr><td><a style=font-size:25px href='info_artistas.php?id=$p[0]'>$p[1]</a></td></tr>";
                            }
                            echo "</table>";

                            echo "<p style=font-size:25px><strong>Nombre: </strong>{$data[0][3]}</p>";
                            echo "<p style=font-size:25px><strong>Año inicio: </strong>{$data[0][4]}</p>";
                            echo "<p style=font-size:25px><strong>Año culminación: </strong>{$data[0][5]}</p>";
                            echo "<p style=font-size:25px><strong>Periodo: </strong>{$data[0][6]}</p>";

                        } else{
                            echo "Oops! Something went wrong. Please try again later.";
                        }
                        // Close statement
                        unset($stmt);
                    }

                    $esculturas = "SELECT material FROM esculturas WHERE oid  = :oid";
                    $pinturas = "SELECT tecnica FROM pinturas  WHERE oid = :oid";
                    $frescos = "SELECT * FROM frescos WHERE oid = :oid";

                    if ($stmt = $db_par->prepare($pinturas)) {
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                        // Set parameters
                        $param_oid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            if($stmt->rowCount() >= 1){
                                $data = $stmt -> fetchall();
                                echo "<p style=font-size:25px><strong>Tipo: </strong>Pintura</p>";
                                echo "<p style=font-size:25px><strong>Técnica:</strong> {$data[0][0]}</p>";
                            }
                        }
                        unset($stmt);
                    }

                    if ($stmt = $db_par->prepare($esculturas)) {
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                        // Set parameters
                        $param_oid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            if($stmt->rowCount() >= 1){
                                $data = $stmt -> fetchall();
                                echo "<p style=font-size:25px><strong>Tipo: </strong>Escultura</p>";
                                echo "<p style=font-size:25px><strong>Material:</strong> {$data[0][0]}</p>";
                            }
                        }
                        unset($stmt);
                    }

                    if ($stmt = $db_par->prepare($frescos)) {
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                        // Set parameters
                        $param_oid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            if($stmt->rowCount() >= 1){
                                $data = $stmt -> fetchall();
                                echo "<p style=font-size:25px><strong>Tipo: </strong>Fresco</p>";
                            }
                        }
                        unset($stmt);
                    }

                ?>
          </div>
    </div>
  </section>

  <section>
    <div class="container">
            <div class="p-5" data-aos="fade-left" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Lugar</h1>
                </div>
                <?php
                    require("../config/conexion.php");
                    $sql = "SELECT l.lid, l.nombre, c.nombre, p.nombre FROM obras o, lugares l, obra_lugar ol, lugar_ciudad lc, ciudades c, pais p, ciudad_pais cp
                    WHERE ol.oid = o.oid AND ol.lid = l.lid AND lc.cid = c.cid AND lc.lid = l.lid AND cp.pid = p.pid AND cp.cid = c.cid AND o.oid = :oid";

                    if($stmt = $db_par->prepare($sql)){
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":oid", $param_oid, PDO::PARAM_STR);
                        // Set parameters
                        $param_oid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            $data = $stmt -> fetchall();
                            $m = False;
                            $museos = "SELECT * FROM museos WHERE lid = :lid";
                            if ($stmt_1 = $db_par->prepare($museos)) {
                                // Bind variables to the prepared statement as parameters
                                $stmt_1->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                                // Set parameters
                                $param_lid = $data[0][0];
                                // Attempt to execute the prepared statement
                                if($stmt_1->execute()){
                                    if($stmt_1->rowCount() >= 1){
                                        $m = True;
                                    }
                                }
                                unset($stmt_1);
                        }
                        if ($m) {
                            echo "<p style=font-size:25px><strong>Nombre: </strong><a style=font-size:25px href='info_museos.php?id={$data[0][0]}'>{$data[0][1]}</a></p>";
                            echo "<p style=font-size:25px><strong>Ciudad: </strong>{$data[0][2]}</p>";
                            echo "<p style=font-size:25px><strong>País: </strong>{$data[0][3]}</p>";
                        } else {
                            echo "<p style=font-size:25px><strong>Nombre: </strong><a style=font-size:25px href='info_lugares.php?id={$data[0][0]}'>{$data[0][1]}</a></p>";
                            echo "<p style=font-size:25px><strong>Ciudad: </strong>{$data[0][2]}</p>";
                            echo "<p style=font-size:25px><strong>País: </strong>{$data[0][3]}</p>";
                        }

                    }else{
                        echo "Oops! Something went wrong. Please try again later.";
                    }
                    // Close statement
                    unset($stmt);
                    }

                    ?>
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

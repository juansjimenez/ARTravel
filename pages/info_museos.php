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
  <link href="../vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom fonts for this template -->
  <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="../css/one-page-wonder.min.css" rel="stylesheet">

  <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

  <link rel="shortcut icon" href="../img/favicon.ico">

  <link href="../css/imagenes.css" rel="stylesheet">

  <script type="text/javascript">
        function buttonclick() {
            alert("¡Compra realizada!")
        }
  </script>

  <style>
    #leftbox {
        float:center;
        /* width:68%; */
        height:180px;
    }

    #leftbox2{
        float:center;
        /* width:96%; */
        height:180px;

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
    <div>
        <div id="leftbox">
            <?php
                require("../config/conexion.php");
                // Prepare a select statement
                $foto = "SELECT url, l.nombre FROM lugares l, fotos_lugares fl WHERE l.lid = fl.lid AND l.lid = :lid";

                if($stmt = $db_par->prepare($foto)){
                    // Bind variables to the prepared statement as parameters
                    $stmt->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                    // Set parameters
                    $param_lid = $_GET['id'];
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
                echo "<br> </br>";
            ?>
            <br> </br>
            <form action="comprar_entrada.php" method="post">
            <input type="hidden" name="id_museo" value="<?php echo $_GET["id"]; ?>">
            <?php
                if ($_SESSION["loggedin"]){
                    echo "<button type='submit' class='btn btn-primary btn-xl rounded-pill mt-5' onclick='buttonclick()' >Comprar entrada</button>";
                } else {
                    echo "<p>Debe Iniciar sesion para poder comprar entradas </p>";
                }
            ?>


        </div>
        <br> </br>
    </div>


  </header>



  <section>
    <div class="container">
            <div class="p-5" data-aos="fade-right" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Lugar</h1>
                </div>
                <?php
                    require("../config/conexion.php");
                    $museos = "SELECT precio_entrada, hora_apertura, hora_cierre FROM museos WHERE lid = :lid";
                    $iglesias = "SELECT hora_apertura, hora_cierre FROM iglesias WHERE lid = :lid";
                    $plazas = "SELECT * FROM plazas WHERE lid = :lid";

                    if ($stmt_1 = $db_par->prepare($museos)) {
                        // Bind variables to the prepared statement as parameters
                        $stmt_1->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                        // Set parameters
                        $param_lid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt_1->execute()){
                            if($stmt_1->rowCount() >= 1){
                                $data_museos = $stmt_1 -> fetchall();
                                $sql = "SELECT l.nombre, c.nombre, p.nombre, p.numero_contacto FROM lugares l, ciudades c, pais p, lugar_ciudad lc, ciudad_pais cp WHERE lc.lid = l.lid AND lc.cid = c.cid AND cp.cid = c.cid AND cp.pid = p.pid AND l.lid = :lid";
                                if($stmt = $db_par->prepare($sql)){
                                    // Bind variables to the prepared statement as parameters
                                    $stmt->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                                    // Set parameters
                                    $param_lid = $_GET['id'];
                                    // Attempt to execute the prepared statement
                                    if($stmt->execute()){
                                        $data = $stmt -> fetchall();
                                        echo "<p  style=font-size:25px><strong>Nombre:</strong> {$data[0][0]}</p>";
                                        echo "<p  style=font-size:25px><strong>Categoría:</strong> Museo</p>";
                                        echo "<p  style=font-size:25px><strong>Precio entrada:</strong> \${$data_museos[0][0]}</p>";
                                        echo "<p  style=font-size:25px><strong>Hora apertura: </strong>{$data_museos[0][1]}</p>";
                                        echo "<p  style=font-size:25px><strong>Hora cierre:</strong> {$data_museos[0][2]}</p>";
                                        echo "<p  style=font-size:25px><strong>Ciudad:</strong> {$data[0][1]}</p>";
                                        echo "<p  style=font-size:25px><strong>País:</strong> {$data[0][2]}</p>";
                                        echo "<p style=font-size:25px><strong>Número contacto:</strong> {$data[0][3]}</p>";

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

                    if ($stmt_1 = $db_par->prepare($iglesias)) {
                        // Bind variables to the prepared statement as parameters
                        $stmt_1->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                        // Set parameters
                        $param_lid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt_1->execute()){
                            if($stmt_1->rowCount() >= 1){
                                $data_iglesias = $stmt_1 -> fetchall();
                                $sql = "SELECT l.nombre, c.nombre, p.nombre, p.numero_contacto FROM lugares l, ciudades c, pais p, lugar_ciudad lc, ciudad_pais cp WHERE lc.lid = l.lid AND lc.cid = c.cid AND cp.cid = c.cid AND cp.pid = p.pid AND l.lid = :lid";

                                if($stmt = $db_par->prepare($sql)){
                                    // Bind variables to the prepared statement as parameters
                                    $stmt->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                                    // Set parameters
                                    $param_lid = $_GET['id'];
                                    // Attempt to execute the prepared statement
                                    if($stmt->execute()){
                                        $data = $stmt -> fetchall();
                                        echo "<h1 style=font-size:25px>Nombre: {$data[0][0]}</h1>";
                                        echo "<h1 style=font-size:25px>Categoría: Iglesia";
                                        echo "<h1 style=font-size:25px>Hora apertura: {$data_iglesias[0][0]}";
                                        echo "<h1 style=font-size:25px>Hora cierre: {$data_iglesias[0][1]}";
                                        echo "<h1 style=font-size:25px>Ciudad: {$data[0][1]}</h1>";
                                        echo "<h1 style=font-size:25px>País: {$data[0][2]}</h1>";
                                        echo "<h1 style=font-size:25px>Número contacto: {$data[0][3]}</h1>";

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

                    if ($stmt_1 = $db_par->prepare($plazas)) {
                        // Bind variables to the prepared statement as parameters
                        $stmt_1->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                        // Set parameters
                        $param_lid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt_1->execute()){
                            if($stmt_1->rowCount() >= 1){
                                $sql = "SELECT l.nombre, c.nombre, p.nombre, p.numero_contacto FROM lugares l, ciudades c, pais p, lugar_ciudad lc, ciudad_pais cp WHERE lc.lid = l.lid AND lc.cid = c.cid AND cp.cid = c.cid AND cp.pid = p.pid AND l.lid = :lid";
                                if($stmt = $db_par->prepare($sql)){
                                    // Bind variables to the prepared statement as parameters
                                    $stmt->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                                    // Set parameters
                                    $param_lid = $_GET['id'];
                                    // Attempt to execute the prepared statement
                                    if($stmt->execute()){
                                        $data = $stmt -> fetchall();
                                        echo "<h1 style=font-size:25px>Nombre: {$data[0][0]}</h1>";
                                        echo "<h1 style=font-size:25px>Categoría: Plaza";
                                        echo "<h1 style=font-size:25px>Ciudad: {$data[0][1]}</h1>";
                                        echo "<h1 style=font-size:25px>País: {$data[0][2]}</h1>";
                                        echo "<h1 style=font-size:25px>Número contacto: {$data[0][3]}</h1>";

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
            <div class="p-5" data-aos="fade-left" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Artistas</h1>
                </div>
                <?php
                    require("../config/conexion.php");
                    // Prepare a select statement
                    $sql = "SELECT DISTINCT a.aid, a.nombre FROM artistas a, obras o, lugares l, hecha_por hp, obra_lugar ol WHERE hp.aid = a.aid AND hp.oid = o.oid AND ol.oid = o.oid AND ol.lid = l.lid AND l.lid = :lid";

                    if($stmt = $db_par->prepare($sql)){
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                        // Set parameters
                        $param_lid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            $data = $stmt -> fetchall();
                            echo "<table class='container'>\n";

                            foreach ($data as $p) {
                                echo "<tr h1 style=font-size:25px><td><a style=font-size:25px href='info_artistas.php?id=$p[0]'>$p[1]</a></td></tr>";
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
  </section>

  <section>
    <div class="container">
            <div class="p-5" data-aos="fade-right" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Obras</h1>
                </div>
                <?php
                    require("../config/conexion.php");
                    // Prepare a select statement
                    $sql = "SELECT DISTINCT o.oid, o.nombre, o.fecha_inicio, o.fecha_culminacion FROM artistas a, obras o, lugares l, hecha_por hp, obra_lugar ol WHERE hp.aid = a.aid AND hp.oid = o.oid AND ol.oid = o.oid AND ol.lid = l.lid AND l.lid = :lid";

                    if($stmt = $db_par->prepare($sql)){
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":lid", $param_lid, PDO::PARAM_STR);
                        // Set parameters
                        $param_lid = $_GET['id'];
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            $data = $stmt -> fetchall();
                            echo "<table class='container'>\n";
                              echo "<tr>";
                              echo "<th style=font-size:25px>Nombre</th>";
                              echo "<th style=font-size:25px>Año inicio</th>";
                              echo "<th style=font-size:25px>Año culminación</th>";
                              echo "</tr>";
                            foreach ($data as $p) {
                                echo "<tr style=font-size:25px><td><a style=font-size:25px href='info_obras.php?id=$p[0]'>$p[1]</a></td><td style=font-size:25px>$p[2]</td><td style=font-size:25px>$p[3]</td></tr>";
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
  </section>

  <!-- Footer -->
  <footer class="py-5 bg-black">
    <div class="container">
      <p class="m-0 text-center text-white small"></p>
    </div>
    <!-- /.container -->
  </footer>

  <!-- Bootstrap core JavaScript -->
  <script src="../vendor/jquery/jquery.min.js"></script>
  <script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="https://unpkg.com/aos@next/dist/aos.js"></script>
  <script>
    AOS.init();
  </script>
</body>

</html>

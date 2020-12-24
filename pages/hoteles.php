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

  <style>
    #leftbox {
        float:center;
        /* width:68%; */
        height:80px;
    }

    #leftbox2{
        float:left;
        width:145%;
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
    <div class="masthead-content">
        <div id="leftbox">
            <h1 style=font-size:100px>Hoteles</h1>
        </div>
    </div>
  </header>

  <section>
    <div class="container">
      <div>
        <div class="col-lg-6">
            <div class="p-5" data-aos="fade-right" data-aos-delay="100">
                <?php
                    require("../config/conexion.php");
                    $sql = "SELECT id_hotel, nombre_hotel FROM Hoteles";

                    if($stmt = $db_impar->prepare($sql)){
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            $data = $stmt -> fetchall();
                            echo "<table class='container'>\n";

                            foreach ($data as $p) {
                                echo "<tr h1 style=font-size:25px><td><a href='info_hoteles.php?id=$p[0]'>$p[1]</a></td></tr>";
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

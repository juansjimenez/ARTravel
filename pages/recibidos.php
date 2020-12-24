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
    <div  class="masthead-content">
        <div id=leftbox>
            <h1 style=font-size:100px>Mensajes</h1>
        <div id=leftbox>
    </div>
  </header>


  <section>
    <div class="container">
            <div class="p-5" data-aos="fade-right" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Recibidos</h1>
                    <?php
                    function mensajes_recibidos($id)
                    {
                      $url ='https://artravel-api.herokuapp.com/messages';
                      $json = file_get_contents($url);
                      $array = json_decode($json, true);
                      $recibidos = array();
                      foreach($array as $mensaje) {
                          if ($mensaje["receptant"] == $id){
                              array_push($recibidos, $mensaje);
                          }
                      }
                      if (count($recibidos) == 0){
                          return "<p style=font-size:25px>No has recibido ningún mensaje.</p>";
                      }
                      return json_encode($recibidos, JSON_PRETTY_PRINT);
                    }

                    $id = $_SESSION["id"];
                    $recived =  json_decode(mensajes_recibidos($id));
                    echo "<table class='table table-striped'>";
                    echo "<thead>";
                    echo "<tr>
                    <th>mid</th>
                    <th>message</th>
                    <th>sender</th>
                    <th>receptant</th>
                    <th>lat</th>
                    <th>long</th>
                    <th>date</th>
                    </tr>";
                    echo "</thead>";
                    echo "<tbody>";
                    foreach ($recived as $message) {
                      echo "<tr>
                      <td>$message->mid</td>
                      <td>$message->message</td>
                      <td>$message->sender</td>
                      <td>$message->receptant</td>
                      <td>$message->lat</td>
                      <td>$message->long</td>
                      <td>$message->date</td>
                      </tr>";
                    }
                    echo "</tbody>";
                    echo "</table>";
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
  <script src="../vendor/jquery/jquery.min.js"></script>
  <script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="https://unpkg.com/aos@next/dist/aos.js"></script>
  <script>
    AOS.init();
  </script>

</body>

</html>

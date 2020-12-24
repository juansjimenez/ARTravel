<?php session_start(); 
require __DIR__ . '/vendor/autoload.php';
?>
<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>ARTravel</title>

  <!-- Bootstrap core CSS -->
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom fonts for this template -->
  <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="css/one-page-wonder.min.css" rel="stylesheet">

  <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

  <link rel="shortcut icon" href="img/favicon.ico">

</head>

<body>
  <!-- Navigation -->
  <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container">
      <a class="navbar-brand" href="./index.php">Home</a>
      <a class="navbar-brand" href="pages/artistas.php">Artistas</a>
      <a class="navbar-brand" href="pages/obras.php">Obras</a>
      <a class="navbar-brand" href="pages/lugares.php">Lugares</a>
      <a class="navbar-brand" href="pages/hoteles.php">Hoteles</a>
      <a class="navbar-brand" href="pages/ticket_transporte.php">Tickets de Transporte </a>
      <a class="navbar-brand" href="pages/generate_itinerary.php"> Itinerarios </a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarResponsive">
        <?php  if($_SESSION["loggedin"]) {?>
        <ul class="navbar-nav ml-auto">
          <li class="nav-item">
            <a class="nav-link" href="./pages/profile.php">My profile</a>
          </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Opciones</a>
                <div class="dropdown-menu">
                <a class="dropdown-item" href="./pages/enviados.php">Mensajes Enviados</a>
                <a class="dropdown-item" href="./pages/recibidos.php">Mensajes Recibidos</a>
                <a class="dropdown-item" href="./pages/datos_enviar.php">Enviar mensaje</a>
                <a class="dropdown-item" href="./pages/datos_text.php">Buscar mensaje</a>
                <a class="dropdown-item" href="./pages/fechas_mapa.php">Mapa de lugares</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="./pages/logout.php">Log Out</a>
                </div>
            </li>
        </ul>
        <?php } else { ?>
        <ul class="navbar-nav ml-auto">
          <li class="nav-item">
            <a class="nav-link" href="./pages/register.php">Sign Up</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="./pages/login.php">Log In</a>
          </li>
        </ul>
        <?php } ?>
      </div>
    </div>
  </nav>

  <header class="masthead text-center text-white">
    <div class="masthead-content">
      <div class="container">
        <br><br><br><br><br><br><br><br>
        <h1 class="masthead-heading mb-0">ARTravel</h1>
      </div>
    </div>
    <div class="bg-circle-1 bg-circle"></div>
    <div class="bg-circle-2 bg-circle"></div>
    <div class="bg-circle-3 bg-circle"></div>
    <div class="bg-circle-4 bg-circle"></div>
    <br><br><br><br><br><br><br><br><br><br><br>
  </header>


  <!-- Footer -->
  <footer class="py-5 bg-black">
    <div class="container">
      <p class="m-0 text-center text-white small"></p>
    </div>
    <!-- /.container -->
    <p style="color:white"> <strong> Made with ⚡ by juansjimenez </strong></p>
  </footer>

  <!-- Bootstrap core JavaScript -->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="https://unpkg.com/aos@next/dist/aos.js"></script>
  <script>
    AOS.init();
  </script>
</body>

</html>

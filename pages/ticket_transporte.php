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
        <h1 style=font-size:100px>Tickets de transporte</h1>
    </div>
</header>

<section>
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <div class="p-5" data-aos="fade-right" data-aos-delay="100">
                    <?php
                    require("../config/conexion.php");
                    $sql = "SELECT cnombre, pnombre, id_ciudad FROM Ciudades";
                    if($stmt = $db_impar->prepare($sql)){
                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            $ciudades = $stmt -> fetchall();
                            ?>

                            <h1>Comprar un ticket:</h1>
                            <form action="info_ticket.php" method="get" class="form-group">
                                <label for="CiudadOrigen">Ciudad Origen:</label>
                                <select class="form-control" id="ciudad_origen", type="text", name="ciudad_origen">
                                    <option value="" selected disabled hidden>Seleccionar...</option>
                                    <?php foreach($ciudades as $c): ?>
                                        <option value=<?php echo "$c[2]" ?>> <?php echo "$c[0], $c[1]"; ?></option>
                                    <?php endforeach; ?>
                                </select><br>

                                <label for="CiudadDestino">Ciudad Destino:</label>
                                <select class="form-control" id="ciudad_destino" type="text" name="ciudad_destino">
                                    <option value="" selected disabled hidden>Seleccionar...</option>
                                    <?php foreach($ciudades as $c): ?>
                                        <option value=<?php echo "$c[2]"?> ><?php echo "$c[0], $c[1]"; ?></option>
                                    <?php endforeach; ?>
                                </select><br>

                                <label for="Fecha">Fecha:</label>
                                <input type="date" value="yyyy-mm-dd" id="fecha" name="fecha" class="form-control"><br>

                                <label for="Medio">Medio:</label>
                                <select class="form-control" id="medio" type="text" name="medio">
                                    <option value="" selected disabled hidden>Seleccionar...</option>
                                    <option>Avión</option>
                                    <option>Bus</option>
                                    <option>Tren</option>
                                </select><br>

                                <input class="btn btn-primary" type="submit" value="Reservar">
                            </form>



                            <?php
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

<?php session_start(); ?>
<!DOCTYPE html>
<html lang="en">

<?php
$mensaje = $_GET['mensaje'];
$username_receptor = $_GET['username_receptor'];
?>

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
                    <h1 style=font-size:100px>Enviar Mensaje</h1>
                    <div id=leftbox>
                    </div>
        </header>


        <section>
            <div class="container">
                <div class="p-5" data-aos="fade-right" data-aos-delay="100">
                    <div class="masthead-content">
                        <h1 style=font-size:45px>Status</h1>
                        <?php

                        function enviar_mensaje($id_dest, $mensaje, $id_env){
                            $url = 'https://artravel-api.herokuapp.com/messages';

                            $contenidos = array('date' => date('Y-m-d', time()), 'long'=> 33.4489,
                                'lat' => 70.6693, 'message' => $mensaje, 'receptant' => $id_dest,
                                'sender' => $id_env);

                            $options = array(
                                'http' => array(
                                    'method'  => 'POST',
                                    'content' => json_encode( $contenidos ),
                                    'header'=>  "Content-Type: application/json\r\n" .
                                        "Accept: application/json\r\n"
                                )
                            );

                            $context  = stream_context_create( $options );
                            $result = file_get_contents( $url, false, $context );
                            $response = json_decode( $result );
                            return $result;

                        }
                        if($_SESSION["loggedin"]) {
                            $id_sender = $_SESSION["id"];
                            require("../config/conexion.php");
                            $sql = "SELECT * FROM Usuarios WHERE username = '$username_receptor'";
                            if ($stmt = $db_impar->prepare($sql)) {
                                // Attempt to execute the prepared statement
                                if ($stmt->execute()) {
                                    $receptor = $stmt->fetchall();
                                }
                            }
                            if (count($receptor)>0){
                                $id_receptor = $receptor[0]['usuario_id'];
                                $status = enviar_mensaje($id_receptor, $mensaje, $id_sender);
                                ?> <label for="Mensaje enviado">El mensaje fue enviado correctamente.</label>
                                <?php

                            } else{
                                ?> <label for="Username Incorrecto">El username ingresado no existe.</label>
                            <?php }
                        } else{
                            ?> <label for="Loggearse">Debe ingresar su usuario antes de enviar un mensaje.</label>
                        <?php }

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

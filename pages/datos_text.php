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
                <h1 style=font-size:100px>Enviar Mensaje</h1>
            </div>
        </header>

        <section>
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <div class="p-5" data-aos="fade-right" data-aos-delay="100">

                            <h1>Ingresa los datos para buscar el mensaje separados por comas (",")</h1>

                            <form action="text_search.php" method="get" class="form-group">
                                <div class="form-group">
                                    <label for="formGroupExampleInput">Palabras deseadas:</label>
                                    <input type="text" class="form-control" id="desired_words" name="desired_words" placeholder="Ingrese palabras deseadas separadas por coma" value="">
                                </div>

                                <div class="form-group">
                                    <label for="formGroupExampleInput">Palabras requeridas:</label>
                                    <input type="text" class="form-control" id="required_words" name="required_words" placeholder="Ingrese palabras requeridas separadas por coma" value="">
                                </div>

                                <div class="form-group">
                                    <label for="formGroupExampleInput">Palabras prohibidas:</label>
                                    <input type="text" class="form-control" id="forbidden_words" name="forbidden_words" placeholder="Ingrese palabras prohibidas separadas por coma" value="">
                                </div>

                                <div class="form-group">
                                    <label for="formGroupExampleInput">Id usuario:</label>
                                    <input type="number" class="form-control" id="user_id" name="user_id" placeholder="Ingrese numero de usuario" value="">
                                </div>

                                <input class="btn btn-primary" type="submit" value="Enviar">
                            </form>

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

<?php session_start(); ?>

<?php
$medio = $_GET['medio'];
$ciudad_origen = $_GET['ciudad_origen'];
$ciudad_destino = $_GET['ciudad_destino'];
$fecha = $_GET['fecha'];
?>

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
                    if($_SESSION["loggedin"]) {
                        require("../config/conexion.php");
                        $sql = "SELECT * FROM Viajes WHERE id_ciudad_origen = $ciudad_origen AND id_ciudad_destino = $ciudad_destino AND medio='$medio'";
                        # $sql = "SELECT cnombre, pnombre, id_ciudad FROM Ciudades";
                        if($stmt = $db_impar->prepare($sql)){
                            // Attempt to execute the prepared statement
                            if($stmt->execute()){
                                $viajes = $stmt -> fetchall();

                                if(count($viajes) == 0){
                                    ?><label for="Error Viaje">El viaje buscado no existe.</label>

                                <?php } else{
                                    foreach ($viajes as $viaje) {
                                        $sql = "SELECT COUNT(*) FROM Tickets WHERE id_viaje= $viaje[id_viaje] and fecha_viaje='$fecha'";
                                        if($stmt = $db_impar->prepare($sql)){
                                            // Attempt to execute the prepared statement
                                            if($stmt->execute()) {
                                                $tickets_vendidos = $stmt->fetchall();
                                                if (intval($tickets_vendidos[0][0]) < $viaje['capacidad_maxima']) {

                                                    $sql = "SELECT COUNT(*) FROM Tickets";
                                                    $stmt = $db_impar->prepare($sql);
                                                    $stmt->execute();
                                                    $id_ticket = $stmt->fetchall();

                                                    $id_ticket_f = $id_ticket[0][0] + 1;
                                                    $usuario_id = $_SESSION["id"];
                                                    $id_viaje = $viaje['id_viaje'];
                                                    $fecha_compra = date("Y-m-d H:i:s" );

                                                    foreach(range(1, $viaje['capacidad_maxima']) as $asiento){
                                                        $sql = "SELECT COUNT(*) FROM Tickets WHERE id_viaje= $viaje[id_viaje] and fecha_viaje='$fecha' and numero_de_asiento=$asiento";
                                                        $stmt = $db_impar->prepare($sql);
                                                        $stmt->execute();
                                                        $id_ticket = $stmt->fetchall();
                                                        if($id_ticket[0][0]==0){
                                                            $numero_de_asiento = $asiento;
                                                            break;
                                                        }
                                                    }
                                                    # fecha ya la tenemos en variable $fecha
                                                    $sql = " INSERT INTO Tickets Values($id_ticket_f, $usuario_id, $id_viaje,'$fecha_compra', $numero_de_asiento, '$fecha')";
                                                    if($stmt = $db_impar->prepare($sql)) {
                                                        // Attempt to execute the prepared statement
                                                        if ($stmt->execute()) {
                                                            ?>
                                                            <h1>Operacion exitosa</h1>
                                                            <h2>Su información: </h2>
                                                            <p>Numero de Ticket: <?php echo "$id_ticket_f" ?></p>
                                                            <p>Fecha de Compra: <?php echo "$fecha_compra" ?></p>
                                                            <p>Fecha de Viaje: <?php echo "$fecha" ?></p>
                                                            <p>Numero de Asiento: <?php echo "$numero_de_asiento" ?></p>
                                                        <?php }
                                                    } else {
                                                        echo "No se pudo comprar el ticket. Intente nuevamente";
                                                    }
                                                    break;
                                                }
                                            } else{
                                                echo 'Debe ingresar una fecha';
                                                break;
                                            }
                                        }}}

                                ?>




                            <?php
                        } else{
                            echo "Oops! Something went wrong. Please try again later.";
                        }
                        // Close statement
                        unset($stmt);
                    }
                    } else { ?>
                        <label for="Loggearse">Debe ingresar su usuario antes de reservar.</label>
                    <?php } ?>
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
<script src="../vendor/jquery/jquery.min.js"></script>
<script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    AOS.init();
</script>
</body>

</html>

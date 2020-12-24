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

  <script type="text/javascript">
        function buttonclick() {
            alert("Reserva realizada")
        }
  </script>

  <style>
    #leftbox {
        float:center;
        /* width:75%; */
        height:100px;
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

    <div >
        <?php
            require("../config/conexion.php");
            // Prepare a select statement
            $hotel = "SELECT nombre_hotel FROM Hoteles WHERE id_hotel = :hid";

            if($stmt = $db_impar->prepare($hotel)){
                // Bind variables to the prepared statement as parameters
                $stmt->bindParam(":hid", $param_hid, PDO::PARAM_STR);
                // Set parameters
                $param_hid = $_GET['id'];
                // Attempt to execute the prepared statement
                if($stmt->execute()){
                    $data = $stmt -> fetchall();

                } else{
                    echo "Oops! Something went wrong. Please try again later.";
                }
                // Close statement
                unset($stmt);
              }

        ?>

    </div>
    <div id="leftbox">
        <?php
            echo "<h1 style=font-size:100px>{$data[0][0]}</h1>";
        ?>
    </div>
  </header>


  <section>
    <div class="container">
            <div class="p-5" data-aos="fade-right" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Hotel</h1>
                </div>
                <?php
                    require("../config/conexion.php");
                    // Prepare a select statement
                    $sql = "SELECT Hoteles.id_hotel, Hoteles.nombre_hotel, Hoteles.direccion, Ciudades.cnombre, Paises.pnombre, Hoteles.telefono, Hoteles.precio FROM Hoteles, Ciudades, Paises WHERE Ciudades.id_ciudad = Hoteles.id_ciudad AND Ciudades.pnombre = Paises.pnombre AND Hoteles.id_hotel = :id_hotel";

                    if($stmt = $db_impar->prepare($sql)){
                        // Bind variables to the prepared statement as parameters
                        $stmt->bindParam(":id_hotel", $param_hid, PDO::PARAM_STR);
                        // Set parameters
                        $param_hid = $_GET['id'];

                        // Attempt to execute the prepared statement
                        if($stmt->execute()){
                            $data = $stmt -> fetchall();


                            echo "<p style=font-size:25px><strong>Direccion:</strong> {$data[0][2]}</p>";
                            echo "<p style=font-size:25px><strong>Ciudad:</strong> {$data[0][3]}</p>";
                            echo "<p style=font-size:25px><strong>Pais: </strong>{$data[0][4]}</p>";
                            echo "<p style=font-size:25px><strong>Telefono:</strong> {$data[0][5]}</p>";
                            echo "<p style=font-size:25px><strong>Precio: </strong>{$data[0][6]}</p>";



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
      <div class="col">
      <div class="row align-items-center">
        <div class="col-lg-6">
            <div class="p-5" data-aos="fade-left" data-aos-delay="100">
                <div class="masthead-content">
                    <h1 style=font-size:45px>Realizar Reserva</h1>
                </div>
            <form align="center" action="hoteles.php" method="post">
            <div class="form-group row">
            <label for="example-date-input"class="col-2 col-form-label">Fecha Llegada</label>
            <div class="col-10">
            <input class="form-control"  name="f_llegada" type="date" value="yyyy-mm-dd" min="<?php echo date("Y-m-d");?>" id="example-date-input">
            </div>
            <label for="example-date-input" class="col-2 col-form-label">Fecha Salida</label>
            <div class="col-10">
            <input class="form-control" name="f_salida" type="date" value="yyyy-mm-dd" min="<?php echo date("Y-m-d");?>"id="example-date-input">
            <input type="hidden" name="id_hotel" value="<?php echo $_GET["id"]; ?>">
            <?php
              if ($_SESSION["loggedin"]){
                $mensaje_pop = '¡Reserva realizada!';
              } else{
                $mensaje_pop = '¡Debe iniciar sesion para reservar una habitacion!';
              }
              echo "<p> IMPORTANTE: Si la fecha de llegada sea menor a la de salida, la reserva no sera registrada."
            ?>

            <button type="submit" formaction="reserva_hotel.php" class="btn btn-primary btn-xl rounded-pill mt-5" onclick="alert('<?php echo $mensaje_pop ?>'); ">Reservar</button>
            </div>
            </div>
            <form>
          </div>
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

<?php session_start();

// Include config file
require("../config/conexion.php");

// Define variables and initialize with empty values
$artists = $initial_city = $initial_date = "";
$artist_err = $initial_city_err = $initial_date_err =  "";

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
  <link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom fonts for this template -->
  <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template -->
  <link href="../css/one-page-wonder.min.css" rel="stylesheet">

  <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />

  <link rel="shortcut icon" href="../img/favicon.ico">

  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.js"></script>

  <link rel="stylesheet" type="text/css" href="//cdn.rawgit.com/davidstutz/bootstrap-multiselect/master/dist/css/bootstrap-multiselect.css">

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
            <h1 style=font-size:100px>Generador de itinerarios</h1>
        </div>
    </div>
  </header>

  <section>
    <div class="container">
      <div>
        <div class="col-lg-6">
            <div class="p-5" data-aos="fade-right" data-aos-delay="100">
            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
            <div class="form-group <?php echo (!empty($artists_err)) ? 'has-error' : ''; ?>">
                <label>Seleccione los artistas cuyas obras esta interesado en visitar</label>
                <div class="form-group">
                    <select id="artistas" name="artists[]" multiple = 'multiple' >
                        <?php
                            $sql = "SELECT aid, nombre FROM artistas";

                            if($stmt = $db_par->prepare($sql)){
                                // Attempt to execute the prepared statement
                                if($stmt->execute()){
                                    $all_artists = $stmt -> fetchAll();
                                    foreach ($all_artists as $p) {
                                        echo "<option value={$p['aid']}>{$p['nombre']}</option>";
                                    }
                                } else{
                                    print_r($stmt->errorInfo());
                                    echo "Oops! Something went wrong. Please try again later.";
                                }

                                // Close statement
                                unset($stmt);
                            }
                        ?>
                    </select>
                </div>
                <span class="help-block"><?php echo $artists; ?></span>
            </div>
            <div class="form-group <?php echo (!empty($initial_date_err)) ? 'has-error' : ''; ?>">
                <label>Seleccione fecha de inicio de su itinerario</label>
                <input type="date" name="date" class="form-control" min="<?php echo date("Y-m-d");?>" value="<?php echo $initial_date; ?>">
                <span class="help-block"><?php echo $initial_date_err; ?></span>
            </div>
            <div class="form-group <?php echo (!empty($initial_city_err)) ? 'has-error' : ''; ?>">
                <label>Ingrese ciudad de inicio de su itinerario</label>
                <select name="city" id="city">
                    <?php
                            $sql = "SELECT cid, nombre FROM ciudades";

                            if($stmt = $db_par->prepare($sql)){
                                // Attempt to execute the prepared statement
                                if($stmt->execute()){
                                    $all_cities = $stmt -> fetchAll();
                                    foreach ($all_cities as $p) {
                                        echo "<option value='{$p['cid']}'>{$p['nombre']}</option>";
                                    }
                                } else{
                                    print_r($stmt->errorInfo());
                                    echo "Oops! Something went wrong. Please try again later.";
                                }

                                // Close statement
                                unset($stmt);
                            }
                        ?>
                </select>
                <span class="help-block"><?php echo $initial_city_err; ?></span>
            </div>
            <div class="form-group">
                <input type="submit" class="btn btn-primary" value="Submit">
            </div>
            </div>
        </div>
      </div>
    </div>
  </section>

  <section id="mostrar_itinerario">
    <div >
      <div class="row align-items-center">
        <div class="col-lg-6">
          <div class="p-5" data-aos="fade-left" data-aos-delay="100">
          <?php
            require("../config/conexion.php");

            if($_SERVER["REQUEST_METHOD"] == "POST"){
                if($_POST["artists"] == ""){
                    $artist_err = "Se debe seleccionar al menor un artista.";
                } else{
                    $artists = $_POST["artists"];
                }
                if(empty(trim($_POST["date"]))){
                    $initial_date_err = "Seleccione una fecha";
                } else{
                    $initial_date = trim($_POST["date"]);
                }
                if(empty(trim($_POST["city"]))){
                    $initial_city_err = "Seleccione una ciudad";
                }else{
                    $initial_city = trim($_POST["city"]);
                }
                if(empty($artists_err) && empty($initial_date_err) && empty($initial_city_err) ){
                    $sql = "SELECT * FROM crear_itinerario(:artists, :initial_city, :initial_date) ORDER BY precio_total";
                    if($stmt = $db_par->prepare($sql)){
                        $stmt->bindParam(":artists", $param_artists);
                        $stmt->bindParam(":initial_city", $param_initial_city, PDO::PARAM_STR);
                        $stmt->bindParam(":initial_date", $param_initial_date, PDO::PARAM_STR);

                        $param_artists = '{'.implode(", ", $artists).'}';
                        $param_initial_city = $initial_city;
                        $param_initial_date = $initial_date;

                        if($stmt->execute()){
                          if($stmt->rowCount() < 1){
                            echo "<h2 class='display-4'>Posibles Itinerarios:</h2>";
                            echo "<h2 class='display-4'>No hay itinerarios posibles</h2>";
                          } else{
                              $contador = 1;
                              $resultados = $stmt -> fetchAll();
                              echo "<h2 class='display-4'>Posibles Itinerarios</h2>";
                              foreach ($resultados as $p){
                                  echo "<pstyle='color:black;'><b>Itinerario N° {$contador}, Precio total: {$p['precio_total']}.</b></p>";
                                  echo "<table class='container'>";
                                  echo "<tr><th>ciudad origen</th><th>ciudad destino</th><th>medio</th><th>fecha salida</th><th>duracion</th><th>precio</th></tr>";
                                  echo "<tr><td>{$p['pos0']}</td><td>{$p['pos1']}</td><td>{$p['medio_v1']}</td><td>{$p['fecha_v1']}</td><td>{$p['duracion_v1']}</td><td>{$p['precio_v1']}</td></tr>";
                                  if ($p['pos2'] != NULL){
                                      echo "<tr><td>{$p['pos1']}</td><td>{$p['pos2']}</td><td>{$p['medio_v2']}</td><td>{$p['fecha_v2']}</td><td>{$p['duracion_v2']}</td><td>{$p['precio_v2']}</td></tr>";
                                      if ($p['pos3'] != NULL){
                                          echo "<tr><td>{$p['pos2']}</td><td>{$p['pos3']}</td><td>{$p['medio_v3']}</td><td>{$p['fecha_v3']}</td><td>{$p['duracion_v3']}</td><td>{$p['precio_v3']}</td></tr>";
                                      }
                                  }
                                  echo "</table>";
                                  echo "<p></p>";
                                  $contador = $contador + 1;
                              }
                            }
                          } else{
                              print_r(implode(", ", $artists));
                              print_r($initial_date);
                              print_r($initial_city);
                              print_r($stmt->errorInfo());
                              echo "Something went wrong. Please try again later.";
                          }


                          // Close statement
                          unset($stmt);

                    }
                }
                unset($db_par);
            }
          ?>
          </div>
        </div>
        <!-- <div class="col-lg-6">
          <div class="p-5" data-aos="fade-right" data-aos-delay="100">
            <h2 class="display-4">Posibles Itinerarios</h2>
          </div>
        </div> -->
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
  <script>
    $(document).ready(function() {
	    $('#artistas').multiselect({
		    nonSelectedText: 'Select artists'
	    });
    });
  </script>
</body>

</html>

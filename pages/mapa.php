<?php session_start();
$start_date = $_POST["start_date"];
$end_date = $_POST["end_date"];
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>
    <style>
        #map {position: absolute; top: 0; bottom: 0; left: 0; right: 0;}
    </style>
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

    <div id="map"></div>
    <script>
        <?php
        function mapa($id, $start_date, $end_date)
        {
          $url ='https://artravel-api.herokuapp.com/users/'.$id;
          $json = file_get_contents($url);
          $array = json_decode($json, true);
          if( isset($array["user_messages"])){
              $enviados = $array["user_messages"];
              $correct = array();
              foreach($enviados as $mensaje) {
                  $date = $mensaje["date"];
                  if ($date >= $start_date && $date <= $end_date){
                      $info = array("lat" => $mensaje["lat"], "long" => $mensaje["long"]);
                      array_push($correct, $info);
                  }
              }
              $correct = json_encode($correct, JSON_PRETTY_PRINT);
              return $correct; }
          return "null";
        }


        ?>

        // Se llama la función de PHP con lo entregado por el usuario en la webapp
        // Hay que cambiar id y las fechas a lo que diga el usuario
        var coords = <?php
            $user_id = $_SESSION["id"];
            echo mapa($user_id, $start_date, $end_date); ?>;

            var southWest = L.latLng(18, 50),
                northEast = L.latLng(18, -40),
                mybounds = L.latLngBounds(southWest, northEast);

        var map = L.map('map', {
                            maxZoom: 20,
                            minZoom: 2.4,
                            zoomControl: false,
                            maxBounds: mybounds,
                            maxBoundsViscocity: 1.0
                        }).setView([0, 0], 2);


        L.control.zoom({position: 'bottomright'}).addTo(map);

        L.tileLayer('https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=vpxaoUNZNWnEdhS3cfHI', {
            attribution: '<a href="https://www.maptiler.com/copyright/" target="_blank">&copy; MapTiler</a> <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap contributors</a>',
        }).addTo(map);

        //Se agregan todos los markers al mapa
        if (typeof coords !== 'string'){
            for (var i = 0; i < coords.length; i++) {
                marker = new L.marker([coords[i]["lat"], coords[i]["long"]]).addTo(map);
            }
        }

    </script>
</body>

</html>

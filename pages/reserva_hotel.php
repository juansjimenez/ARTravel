<?php
session_start();

$id_hotelP = $_POST["id_hotel"];
$fecha_llegada = $_POST["f_llegada"];
$fecha_salida = $_POST["f_salida"];
if($_SESSION["loggedin"]) {
    $id_usuario = $_SESSION["id"];
    }
;
require("../config/conexion.php");

$sql = "SELECT MAX(id_reserva) FROM Reservas";

if($stmt = $db_impar->prepare($sql)){
    // Attempt to execute the prepared statement
    if($stmt->execute()){
        $max_id = $stmt -> fetchAll();
        $max_reserva = $max_id[0][0];
        $reserva_id = $max_reserva + 1;
    } else{
        echo "Oops! Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}

if ($fecha_llegada < $fecha_salida){
    $sql = "INSERT INTO Reservas (id_reserva, id_hotel, usuario_id, fecha_llegada, fecha_salida) VALUES (:id_reserva, :id_hotel, :usuario_id, :fecha_llegada, :fecha_salida)";

    if($stmt = $db_impar->prepare($sql)){
        // Bind variables to the prepared statement as parameters
        $stmt->bindParam(":id_reserva", $param_reserva, PDO::PARAM_STR);
        $stmt->bindParam(":id_hotel", $param_hotel, PDO::PARAM_STR);
        $stmt->bindParam(":usuario_id", $param_usuario, PDO::PARAM_STR);
        $stmt->bindParam(":fecha_llegada", $param_llegada, PDO::PARAM_STR);
        $stmt->bindParam(":fecha_salida", $param_salida, PDO::PARAM_STR);


        // Set parameters
        $param_reserva = $reserva_id;
        $param_hotel = $id_hotelP;
        $param_usuario = $id_usuario;
        $param_llegada = $fecha_llegada;
        $param_salida = $fecha_salida;


        // Attempt to execute the prepared statement
        if($stmt->execute()){
            // Redirect to login page
        } else{
            echo "Something went wrong. Please try again later.";
        }

        // Close statement
        unset($stmt);
    }


    // Close connection
    unset($db_impar);
    header("Location: info_hoteles.php?id={$id_hotelP}");
    exit;

}
header("Location: info_hoteles.php?id={$id_hotelP}");
?>

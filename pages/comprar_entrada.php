<?php
session_start();
require("../config/conexion.php");

$id_museo = $_POST["id_museo"];
if($_SESSION["loggedin"]) {
    $id_usuario = $_SESSION["id"];
    }


$fecha = date("Y-m-d");

$sql = "INSERT INTO entradas_museos (uid, lid, fecha_compra) VALUES (:uid, :lid, :fecha_compra)";

if($stmt = $db_par->prepare($sql)){
    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":uid", $param_usuario, PDO::PARAM_STR);
    $stmt->bindParam(":lid", $param_museo, PDO::PARAM_STR);
    $stmt->bindParam(":fecha_compra", $param_fecha, PDO::PARAM_STR);


    // Set parameters
    $param_usuario = $id_usuario;
    $param_museo = $id_museo;
    $param_fecha = $fecha;


    // Attempt to execute the prepared statement
    if($stmt->execute()){
        // Redirect to login page
        header("Location: info_museos.php?id={$id_museo}");

    } else{
        print_r($stmt->errorInfo());
        echo "Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}


// Close connection
unset($db_impar);
   exit;
?>

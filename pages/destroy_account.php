<?php
// Initialize the session
session_start();
require("../config/conexion.php");

// Prepare an insert statement
$sql = "DELETE FROM usuarios WHERE usuario_id = :user_id";

if($stmt = $db_par->prepare($sql)){
    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);


    // Set parameters
    $param_user_id = $_SESSION["id"];


    // Attempt to execute the prepared statement
    if($stmt->execute()){
    } else{
        echo "Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}


// Close connection
unset($db_par);
// Prepare an insert statement
$sql = "DELETE FROM usuarios WHERE usuario_id = :user_id";

if($stmt = $db_impar->prepare($sql)){
    // Bind variables to the prepared statement as parameters
    $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);


    // Set parameters
    $param_user_id = $_SESSION["id"];


    // Attempt to execute the prepared statement
    if($stmt->execute()){
    } else{
        echo "Something went wrong. Please try again later.";
    }

    // Close statement
    unset($stmt);
}


// Close connection
unset($db_impar);


// Unset all of the session variables
$_SESSION = array();

// Destroy the session.
session_destroy();

// Redirect to login page
header("location: ../index.php");
exit;
?>

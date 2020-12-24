<!DOCTYPE html>
<head>
    <title>ARTravel</title>
    <link rel="shortcut icon" href="../img/favicon.ico">
<head>

<?php
// Include config file
require("../config/conexion.php");

// Define variables and initialize with empty values
$username = $name = $mail = $address = $user_id = $password = $confirm_password ="";
$username_err = $name_err = $mail_err = $address_err = $password_err = $confirm_password_err = "";

// Processing form data when form is submitted
if($_SERVER["REQUEST_METHOD"] == "POST"){

    // Validate username
    if(empty(trim($_POST["username"]))){
        $username_err = "Please enter a username.";
    } else{
        // Prepare a select statement
        $sql = "SELECT usuario_id FROM usuarios WHERE username = :username";

        if($stmt = $db_impar->prepare($sql)){
            // Bind variables to the prepared statement as parameters
            $stmt->bindParam(":username", $param_username, PDO::PARAM_STR);

            // Set parameters
            $param_username = trim($_POST["username"]);

            // Attempt to execute the prepared statement
            if($stmt->execute()){
                if($stmt->rowCount() == 1){
                    $username_err = "This username is already taken.";
                } else{
                    $username = trim($_POST["username"]);
                }
            } else{
                echo "Oops! Something went wrong. Please try again later.";
            }

            // Close statement
            unset($stmt);
        }
    }

    // Validate name
    if(empty(trim($_POST["name"]))){
        $name_err = "Please enter a name.";
    } else{
        $name = trim($_POST["name"]);
    }

    // Validate mail
    if(empty(trim($_POST["mail"]))){
        $mail_err = "Please enter a e-mail address.";
    } else{
        if (filter_var(trim($_POST["mail"]), FILTER_VALIDATE_EMAIL)) {
            $mail = trim($_POST["mail"]);;
        } else {
            $mail_err = "Please enter a valid e-mail address.";
        }
    }

    // Validate address
    if(empty(trim($_POST["address"]))){
        $address_err = "Please enter an address.";
    } else{
        $address = trim($_POST["address"]);
    }

    //get new user id
    $sql = "SELECT MAX(usuario_id) FROM usuarios";

    if($stmt = $db_impar->prepare($sql)){
        // Attempt to execute the prepared statement
        if($stmt->execute()){
            $max_id = $stmt -> fetchAll();
            $user_id = $max_id[0][0];
        } else{
            echo "Oops! Something went wrong. Please try again later.";
        }

        // Close statement
        unset($stmt);
    }

    // Validate password
    if(empty(trim($_POST["password"]))){
        $password_err = "Please enter a password.";
    } elseif(strlen(trim($_POST["password"])) < 6){
        $password_err = "Password must have atleast 6 characters.";
    } else{
        $password = trim($_POST["password"]);
    }

    // Validate confirm password
    if(empty(trim($_POST["confirm_password"]))){
        $confirm_password_err = "Please confirm password.";
    } else{
        $confirm_password = trim($_POST["confirm_password"]);
        if(empty($password_err) && ($password != $confirm_password)){
            $confirm_password_err = "Password did not match.";
        }
    }

    // Check input errors before inserting in database
    if(empty($username_err) && empty($name_err) && empty($mail_err) && empty($address_err) && empty($password_err) && empty($confirm_password_err)){
        // Prepare an insert statement
        $sql = "INSERT INTO usuarios (usuario_id, username, nombre, correo, direccion, password) VALUES (:user_id, :username, :name, :mail, :address, :password)";

        if($stmt = $db_par->prepare($sql)){
            // Bind variables to the prepared statement as parameters
            $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);
            $stmt->bindParam(":username", $param_username, PDO::PARAM_STR);
            $stmt->bindParam(":name", $param_name, PDO::PARAM_STR);
            $stmt->bindParam(":mail", $param_mail, PDO::PARAM_STR);
            $stmt->bindParam(":address", $param_address, PDO::PARAM_STR);
            $stmt->bindParam(":password", $param_password, PDO::PARAM_STR);

            // Set parameters
            $param_user_id = intval($user_id+1);
            $param_username = $username;
            $param_name = $name;
            $param_mail = $mail;
            $param_address = $address;
            $param_password = password_hash($password, PASSWORD_DEFAULT); // Creates a password hash


            // Attempt to execute the prepared statement
            if($stmt->execute()){
            } else{
                echo "Something went wrongs. Please try again laters.";
            }

            // Close statement
            unset($stmt);
        }


    // Close connection
    unset($db_par);
        // Prepare an insert statement
        $sql = "INSERT INTO usuarios (usuario_id, username, nombre, correo, direccion, password) VALUES (:user_id, :username, :name, :mail, :address, :password)";

        if($stmt = $db_impar->prepare($sql)){
            // Bind variables to the prepared statement as parameters
            $stmt->bindParam(":user_id", $param_user_id, PDO::PARAM_STR);
            $stmt->bindParam(":username", $param_username, PDO::PARAM_STR);
            $stmt->bindParam(":name", $param_name, PDO::PARAM_STR);
            $stmt->bindParam(":mail", $param_mail, PDO::PARAM_STR);
            $stmt->bindParam(":address", $param_address, PDO::PARAM_STR);
            $stmt->bindParam(":password", $param_password, PDO::PARAM_STR);

            // Set parameters
            $param_user_id = intval($user_id+1);
            $param_username = $username;
            $param_name = $name;
            $param_mail = $mail;
            $param_address = $address;
            $param_password = password_hash($password, PASSWORD_DEFAULT); // Creates a password hash


            // Attempt to execute the prepared statement
            if($stmt->execute()){
                // Redirect to login page
                header("location: ../index.php");
            } else{
                echo "Something went wrongs. Please try again laters.";
            }

            // Close statement
            unset($stmt);
        }
    }

    // Close connection
    unset($db_impar);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.css">
    <style type="text/css">
        body{ font: 14px sans-serif; }
        .wrapper{ width: 350px; padding: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="wrapper">
            <h2>Sign Up</h2>
            <p>Please fill this form to create an account.</p>
            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                <div class="form-group <?php echo (!empty($username_err)) ? 'has-error' : ''; ?>">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" value="<?php echo $username; ?>">
                    <span class="help-block"><?php echo $username_err; ?></span>
                </div>
                <div class="form-group <?php echo (!empty($name_err)) ? 'has-error' : ''; ?>">
                    <label>Name</label>
                    <input type="text" name="name" class="form-control" value="<?php echo $name; ?>">
                    <span class="help-block"><?php echo $name_err; ?></span>
                </div>
                <div class="form-group <?php echo (!empty($mail_err)) ? 'has-error' : ''; ?>">
                    <label>E-mail</label>
                    <input type="text" name="mail" class="form-control" value="<?php echo $mail; ?>">
                    <span class="help-block"><?php echo $mail_err; ?></span>
                </div>
                <div class="form-group <?php echo (!empty($address_err)) ? 'has-error' : ''; ?>">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control" value="<?php echo $address; ?>">
                    <span class="help-block"><?php echo $address_err; ?></span>
                </div>
                <div class="form-group <?php echo (!empty($password_err)) ? 'has-error' : ''; ?>">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" value="<?php echo $password; ?>">
                    <span class="help-block"><?php echo $password_err; ?></span>
                </div>
                <div class="form-group <?php echo (!empty($confirm_password_err)) ? 'has-error' : ''; ?>">
                    <label>Confirm Password</label>
                    <input type="password" name="confirm_password" class="form-control" value="<?php echo $confirm_password; ?>">
                    <span class="help-block"><?php echo $confirm_password_err; ?></span>
                </div>
                <div class="form-group">
                    <input type="submit" class="btn btn-primary" value="Submit">
                    <input type="reset" class="btn btn-default" value="Reset">
                </div>
                <p>Already have an account? <a href="login.php">Login here</a>.</p>
                <p><a href="../index.php">Return to Homepage</a>.</p>
            </form>
        </div>
    </div>
</body>
</html>

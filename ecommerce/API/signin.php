<?php

$db = mysqli_connect('localhost', 'root', '', 'e-commerce');
if (!$db) {
    die("Database connection failed: " . mysqli_connect_error());
}

if (isset($_POST['email']) && isset($_POST['password'])) {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Validate username and password (add your validation logic here)

    // Check if the user exists
    $query = "SELECT id, email, password FROM users WHERE email = ?";
    $stmt = mysqli_prepare($db, $query);
    mysqli_stmt_bind_param($stmt, "s", $email);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if (mysqli_num_rows($result) == 1) {
        $row = mysqli_fetch_assoc($result);
        $storedPassword = $row['password'];

        // Verify the password
        if (password_verify($password, $storedPassword)) {
            // Generate a token
            $token = bin2hex(random_bytes(16));

            // Save the token in the database
            $userId = $row['id'];
            $query = "UPDATE users SET token = ? WHERE id = ?";
            $stmt = mysqli_prepare($db, $query);
            mysqli_stmt_bind_param($stmt, "si", $token, $userId);
            mysqli_stmt_execute($stmt);

            // Return the token and email to the client
            $response = array('status' => 'Success', 'token' => $token, 'email' => $email);
            echo json_encode($response);
        } else {
            $response = array('status' => 'Error', 'message' => 'Invalid email or password');
            echo json_encode($response);
        }
    } else {
        $response = array('status' => 'Error', 'message' => 'Invalid email or password');
        echo json_encode($response);
    }

    mysqli_stmt_close($stmt);
} else {
    $response = array('status' => 'Error', 'message' => 'Email or password is missing');
    echo json_encode($response);
}

mysqli_close($db);

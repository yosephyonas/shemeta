<?php
$db = mysqli_connect('localhost', 'root', '', 'e-commerce');
if (!$db) {
    die("Database connection failed: " . mysqli_connect_error());
}

$email = $_POST['email'];
$password = $_POST['password'];

// Validate username and password (add your validation logic here)

// Check if the username already exists
$query = "SELECT email FROM users WHERE email = ?";
$stmt = mysqli_prepare($db, $query);
mysqli_stmt_bind_param($stmt, "s", $email);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if (mysqli_num_rows($result) == 1) {
    echo json_encode("Error");
} else {
    // Hash the password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Insert the user into the database
    $query = "INSERT INTO users (email, password) VALUES (?, ?)";
    $stmt = mysqli_prepare($db, $query);
    mysqli_stmt_bind_param($stmt, "ss", $email, $hashedPassword);
    mysqli_stmt_execute($stmt);

    if (mysqli_stmt_affected_rows($stmt) > 0) {
        echo json_encode("Success");
    } else {
        echo json_encode("Error");
    }

    mysqli_stmt_close($stmt);
}

mysqli_close($db);

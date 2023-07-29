<?php

$db = mysqli_connect('localhost', 'root', '', 'e-commerce');
if (!$db) {
    die("Database connection failed: " . mysqli_connect_error());
}

// Check if the username and password are setx
if (isset($_POST['username'], $_POST['password'])) {
    // Retrieve the posted data
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Prepare the query statement
    $stmt = $db->prepare("SELECT * FROM admins WHERE username = ?");
    $stmt->bind_param("s", $username);

    // Execute the query
    $stmt->execute();

    // Get the result
    $result = $stmt->get_result();

    // Check if the user exists
    if ($result->num_rows > 0) {
        // Fetch the user data
        $row = $result->fetch_assoc();
        $storedPassword = $row['password'];

        // Verify the password
        if (password_verify($password, $storedPassword)) {
            // Login successful
            $response = array(
                'status' => 'Success',
                'message' => 'Login successful'
            );
        } else {
            // Incorrect password
            $response = array(
                'status' => 'Error',
                'message' => 'Incorrect password'
            );
        }
    } else {
        // User not found
        $response = array(
            'status' => 'Error',
            'message' => 'User not found'
        );
    }

    // Close the database connection
    $stmt->close();
} else {
    // Username or password not set, return error response
    $response = array(
        'status' => 'Error',
        'message' => 'Username or password missing'
    );
}

// Return the response as JSON
echo json_encode($response);
?>

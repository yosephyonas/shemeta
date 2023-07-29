<?php
include_once 'config.php';

// Check if the user is logged in
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_COOKIE['token'])) {
  // Retrieve user information based on the token
  $token = $_COOKIE['token'];

  // Prepare and execute the SQL query
  $stmt = $conn->prepare('SELECT id,  email FROM users WHERE token = ?');
  $stmt->bind_param('s', $token);
  $stmt->execute();
  $result = $stmt->get_result();

  if ($result->num_rows > 0) {
    // Fetch the user information
    $user = $result->fetch_assoc();

    // Return user information in JSON format
    header('Content-Type: application/json');
    echo json_encode($user);
  } else {
    echo "No user found";
  }

  $stmt->close();
} else {
  echo "Invalid request";
}

$conn->close();
?>

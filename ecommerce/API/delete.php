<?php
// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "e-commerce";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Set headers to allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];

    // Perform the delete operation in the database
    $stmt = $conn->prepare("DELETE FROM products WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();

    // Check if the delete was successful
    if ($stmt->affected_rows > 0) {
        // Return a success message
        $response = ['success' => true, 'message' => 'Product deleted successfully'];
        http_response_code(200);
    } else {
        // Return an error message
        $response = ['success' => false, 'message' => 'Failed to delete product'];
        http_response_code(400);
    }

    // Send the response as JSON
    echo json_encode($response);
}

$conn->close();
?>

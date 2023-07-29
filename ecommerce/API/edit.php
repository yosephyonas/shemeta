<?php
// Establish database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "e-commerce";

$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Get the product ID and updated values from the request
$id = $_POST['id'];
$name = $_POST['name'];
$description = $_POST['description'];
$price = $_POST['price'];

// Prepare the UPDATE query
$sql = "UPDATE products SET name = '$name', description = '$description', price = '$price' WHERE id = '$id'";

if (mysqli_query($conn, $sql)) {
    // Query executed successfully
    echo "Product updated successfully";
} else {
    // Failed to execute the query
    echo "Error updating product: " . mysqli_error($conn);
}

// Close the database connection
mysqli_close($conn);
?>

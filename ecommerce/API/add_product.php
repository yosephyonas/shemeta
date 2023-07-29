<?php

use PSpell\Config;

header('Access-Control-Allow-Origin: *');
header('Content-type: application/json');
header('Access-Control-Allow-Method: POST');
header('Access-Control-Allow-Headers: Origin, Content-type, Accept');

include_once 'config.php';

// Check if required fields are present
if (!isset($_POST['name']) || !isset($_POST['description']) || !isset($_POST['price'])) {
    http_response_code(400);
    echo json_encode(array('message' => 'Missing required fields'));
    exit();
}

$name = $_POST['name'];
$description = $_POST['description'];
$price = $_POST['price'];

// Check if image file is present
if (!isset($_FILES['image'])) {
    http_response_code(400);
    echo json_encode(array('message' => 'Image file is required'));
    exit();
}

$imageFile = $_FILES['image'];

// Check if image upload was successful
if ($imageFile['error'] !== UPLOAD_ERR_OK) {
    http_response_code(500);
    echo json_encode(array('message' => 'Failed to upload image'));
    exit();
}

// Define the directory to store the uploaded images
$uploadDir = '../../assets/';
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

// Generate a unique filename for the uploaded image
$fileName = uniqid() . '_' . $imageFile['name'];
$filePath = $uploadDir . $fileName;

// Move the uploaded image file to the desired location
if (!move_uploaded_file($imageFile['tmp_name'], __DIR__ . '/' . $filePath)) {
    http_response_code(500);
    echo json_encode(array('message' => 'Failed to move image file'));
    exit();
}

// Add the product to the database along with the image file path
$sql = "INSERT INTO products (name, description, price, image) VALUES ('$name', '$description', '$price', '$filePath')";

if ($conn->query($sql) === TRUE) {
    http_response_code(200);
    echo json_encode(array('message' => 'Product added successfully'));
} else {
    http_response_code(500);
    echo json_encode(array('message' => 'Failed to add product'));
}

$conn->close();
?>

<?php

header('Access-Control-Allow-Origin: *');
header('Content-type: application/json');
header('Access-Control-Allow-Method: POST');
header('Access-Control-Allow-Headers: Origin, Content-type, Accept');

include_once 'config.php';

// Base URL for the images
$baseURL = 'http://192.168.1.63/ecommerce/assets/';

// Retrieve all products from the database
$sql = "SELECT * FROM products";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $products = array();

    while ($row = $result->fetch_assoc()) {
        $product = array(
            'id' => $row['id'],
            'name' => $row['name'],
            'description' => $row['description'],
            'price' => $row['price'],
            'image' => $baseURL . $row['image']
        );

        $products[] = $product;
    }

    http_response_code(200);
    echo json_encode($products);
} else {
    http_response_code(404);
    echo json_encode(array('message' => 'No products found'));
}

$conn->close();

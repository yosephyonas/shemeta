import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final TextEditingController productNameController = TextEditingController();

  final TextEditingController productDescriptionController =
      TextEditingController();

  final TextEditingController productPriceController = TextEditingController();

  File? imageFile;

  Future<void> addProduct() async {
    const url = 'http://192.168.1.63/ecommerce/API/add_product.php';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = productNameController.text;
    request.fields['description'] = productDescriptionController.text;
    request.fields['price'] = productPriceController.text;

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      showSuccessSnackbar('Product added successfully');
      // Clear the input fields
      productNameController.clear();
      productDescriptionController.clear();
      productPriceController.clear();
      setState(() {
        imageFile = null;
      });
    } else {
      showErrorSnackbar('Failed to add product');
    }

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${await response.stream.bytesToString()}');
  }

  Future<void> pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    } else {
      // Handle the case when no image is picked
      print('No image selected');
    }
  }

  Future<void> showImageSourceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      animationDuration: const Duration(milliseconds: 500),
      borderRadius: 10.0,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      overlayBlur: 0.5,
      overlayColor: Colors.black.withOpacity(0.5),
      snackStyle: SnackStyle.FLOATING,
      barBlur: 0.5,
      shouldIconPulse: true,
      icon: const Icon(Icons.error),
      mainButton: TextButton(
        onPressed: () {
          // Perform any action here when the main button is clicked
        },
        child: const Text(
          'Retry',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: (_) {
        // Perform any action here when the Snackbar is tapped
      },
    );
  }

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      animationDuration: const Duration(milliseconds: 500),
      borderRadius: 10.0,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      overlayBlur: 0.5,
      overlayColor: Colors.black.withOpacity(0.5),
      snackStyle: SnackStyle.FLOATING,
      barBlur: 0.5,
      shouldIconPulse: false,
      icon: const Icon(Icons.check),
      onTap: (_) {
        // Perform any action here when the Snackbar is tapped
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0, // Remove the app bar shadow
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Product Description',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: productPriceController,
                  decoration: InputDecoration(
                    labelText: 'Product Price',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => showImageSourceDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Select Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                if (imageFile != null)
                  Image.file(
                    imageFile!,
                    height: 150,
                    width: 150,
                  ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

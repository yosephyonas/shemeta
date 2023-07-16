import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'EditProductPage.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with the existing product data
    productNameController.text = widget.product.name;
    productDescriptionController.text = widget.product.description;
    productPriceController.text = widget.product.price.toString();
  }

  @override
  void dispose() {
    // Clean up the text controllers
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();

    super.dispose();
  }

  Future<void> saveChanges() async {
    final updatedName = productNameController.text;
    final updatedDescription = productDescriptionController.text;
    final updatedPrice = double.parse(productPriceController.text);

    final updatedProduct = Product(
      id: widget.product.id,
      name: updatedName,
      description: updatedDescription,
      price: updatedPrice,
      image: widget.product.image,
    );

    Navigator.pop(context, updatedProduct);

    try {
      const url = 'http://192.168.1.63/ecommerce/API/edit.php';
      final response = await http.post(Uri.parse(url), body: {
        'id': widget.product.id.toString(),
        'name': updatedName,
        'description': updatedDescription,
        'price': updatedPrice.toString(),
      });

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Product changes saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to save product changes');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to save product changes: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        const url = 'http://192.168.1.63/ecommerce/API/delete.php';
        final response = await http.post(Uri.parse(url), body: {
          'id': widget.product.id.toString(),
        });

        if (response.statusCode == 200) {
          Navigator.pop(context);

          Get.snackbar(
            'Success',
            'Product deleted successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw Exception('Failed to delete product');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete product: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Edit Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: productDescriptionController,
              decoration: InputDecoration(
                
                labelText: 'Product Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: productPriceController,
              decoration: InputDecoration(
                fillColor: Colors.amber,
                labelText: 'Product Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black)
                  
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: deleteProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Delete Product',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

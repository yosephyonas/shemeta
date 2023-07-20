// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ProductDetailPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> fetchProducts() async {
    try {
      var url = 'http://192.168.1.63/ecommerce/API/get_products.php';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List<dynamic> productList = responseData as List;
        setState(() {
          products = productList.map((json) => Product.fromJson(json)).toList();
        });
      } else {
        print('Failed to fetch products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: RefreshIndicator(
        onRefresh: refreshProducts,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        // Handle search logic here
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Our Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(category: categories[index]);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Product extends GetxController {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final RxBool selected;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    bool isSelected = false,
  }) : selected = isSelected.obs;

  void toggleSelected() {
    selected.value = !selected.value;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      image: json['image'],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(2)} Birr',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

final List<String> categories = [
  'Cloth',
  'Cars',
  'Furnitures',
  'Construction',
  'Cosmotics'
  // Add more categories as needed
];

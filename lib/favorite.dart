import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'MainPage.dart';
import 'ProductDetailPage.dart';
import 'home.dart';

class FavoriteController extends GetxController {
  final favorites = <dynamic>[].obs;

  void addFavorite(dynamic product) {
    favorites.add(product);
  }

  void removeFavorite(dynamic product) {
    favorites.remove(product);
  }
}

class FavoritePage extends StatelessWidget {
  final FavoriteController favoriteController = Get.put(FavoriteController());

  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
              'My Favorites',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ), ],
              ),
            ),
            const SizedBox(width: 8.0),
         
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: favoriteController.favorites.length,
                  itemBuilder: (context, index) {
                    dynamic product = favoriteController.favorites[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ProductCard(product: product),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
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

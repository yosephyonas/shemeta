import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'MainPage.dart';

class ReceivedOrdersController extends GetxController {
  final RxList<Product> receivedOrders = <Product>[].obs;

  void addOrders(List<Product> orders) {
    receivedOrders.addAll(orders);
  }
}

class ReceivedOrdersPage extends StatelessWidget {
  final ReceivedOrdersController receivedOrdersController =
      Get.find<ReceivedOrdersController>();

   ReceivedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Received Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (receivedOrdersController.receivedOrders.isEmpty) {
                  return const Center(
                    child: Text('No received orders.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: receivedOrdersController.receivedOrders.length,
                    itemBuilder: (context, index) {
                      final product = receivedOrdersController.receivedOrders[index];
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          'Price: \$${product.price.toStringAsFixed(2)}',
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shemeta/home.dart';
import 'MainPage.dart';
import 'ReceivedOrdersPage.dart';

class OrderController extends GetxController {
  final RxList<Product> orderList = <Product>[].obs;

  void addToCart(Product product) {
    orderList.add(product);
  }

  void clearCart() {
    orderList.removeWhere((product) => product.selected.value);
  }
}

class OrderPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());
  final receivedOrdersController = Get.find<ReceivedOrdersController>();

  OrderPage({Key? key});

  void placeOrder() {
    final selectedProducts = orderController.orderList
        .where((product) => product.selected.value)
        .toList();
    if (selectedProducts.isEmpty) {
      Get.snackbar('Orders', 'No products selected.');
    } else {
      // Clear the cart
      orderController.clearCart();

      // Update the received orders list in the ReceivedOrdersPage
      Get.find<ReceivedOrdersController>().addOrders(selectedProducts
          .map((product) => Product(
                image: product.image,
                name: product.name,
                price: product.price,
                id: product.id,
                description: product.description,
              ))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
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
                  const SizedBox(width: 8.0),
                  const Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  if (orderController.orderList.isEmpty) {
                    return const Center(
                      child: Text('Your cart is empty.'),
                    );
                  } else {
                    final selectedProducts = orderController.orderList
                        .where((product) => product.selected.value)
                        .toList();
                    final totalPrice = selectedProducts.fold<double>(
                        0, (sum, product) => sum + product.price);

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: orderController.orderList.length,
                            itemBuilder: (context, index) {
                              final product = orderController.orderList[index];
                              return ListTile(
                                leading: Checkbox(
                                  value: product.selected.value,
                                  onChanged: (value) {
                                    product.selected.value = value!;
                                  },
                                ),
                                title: Text(product.name),
                                subtitle: Text(
                                  'Price: \$${product.price.toStringAsFixed(2)}',
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: placeOrder,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.all(14.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                                child: const Text(
                                  'Order Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                          
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

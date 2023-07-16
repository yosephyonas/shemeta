import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shemeta/admin_page.dart';
import 'package:shemeta/getstarted_page.dart';
import 'OrderPage.dart';
import 'ReceivedOrdersPage.dart';
import 'favorite.dart';
import 'home.dart';
import 'user_controller.dart';
import 'signin_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MyApp(),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());
  final FavoriteController favoriteController = Get.put(FavoriteController());
  final receivedOrdersController = Get.put(ReceivedOrdersController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/get_started', page: () => const GetStartedPage()),
        GetPage(name: '/home', page: () => const Home()),
        GetPage(name: '/signin', page: () => SigninPage()),
        GetPage(name: '/admin_page', page: () => const AdminPage()),
        GetPage(name: '/received_orders', page: () => ReceivedOrdersPage()),
      ],
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Initialize the user data controller
            UserController userController = Get.put(UserController());

            // Check the login status
            SharedPreferences prefs = snapshot.data!;
            bool loggedIn = prefs.getBool('loggedIn') ?? false;
            if (loggedIn) {
              String? userEmail = prefs.getString('userData');
              if (userEmail != null) {
                userController.loginUser(
                    userEmail, ''); // Set the logged-in user data
                return const Home(); // Navigate to the home page
              }
            }
            // Redirect the user to the GetStartedPage
            return const GetStartedPage();
          } else {
            return const CircularProgressIndicator(); // Handle loading state
          }
        },
      ),
    );
  }
}

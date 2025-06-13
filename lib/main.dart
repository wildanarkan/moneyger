// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moneyger_3_24/controllers/home_controller.dart';
import 'package:moneyger_3_24/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Moneyger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Inter', // Optional: add custom font
      ),
      // Initialize controllers
      initialBinding: AppBinding(),
      home: const HomePage(),
    );
  }
}

// Binding class to initialize controllers
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize HomeController when app starts
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

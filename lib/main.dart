import 'package:expense_tracker_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/expense_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ExpenseController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        // Light Theme
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        // Dark Theme
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        brightness: Brightness.dark,
      ),

      themeMode: ThemeMode.system, // Yeh important hai!

      home: HomeScreen(),
    );
  }
}

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'views/home_page.dart'; // Sesuaikan path

void main() {
  runApp(const PusepuhApp());
}

class PusepuhApp extends StatelessWidget {
  const PusepuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ubah MaterialApp menjadi GetMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'pusepuh',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pusepuh_mobile/home_page.dart';

void main() {
  runApp(const PusepuhApp());
}

class PusepuhApp extends StatelessWidget {
  const PusepuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
import 'package:flutter/material.dart';
import 'Service/Login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Iniciamos la pantalla en el login
      home: LoginScreen(),
    );
  }
}

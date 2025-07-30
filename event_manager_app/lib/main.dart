import 'package:flutter/material.dart';
import 'lib/login.dart';
//import 'lib/register.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App', debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.kalniaTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
        );
  }
}

import 'package:event_manager_app/server_locator.dart';
import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import './screens/home_screen.dart';

void main() {
  setupServerLocator();
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        //buy ticket nên là dạng pop-up sasa
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
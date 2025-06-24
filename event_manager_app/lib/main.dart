import 'package:flutter/material.dart';
import './screens/signup_page.dart';
import './screens/login_page.dart';
import './screens/home_page.dart';
import './screens/buy_a_ticket.dart';

void main() {
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
      home: HomePage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        //buy ticket nên là dạng pop-up sasa
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
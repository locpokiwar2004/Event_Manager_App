import 'package:event_manager_app/core/di/injection_container.dart' as di;
import 'package:event_manager_app/server_locator.dart';
import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/organizer/organizer_dashboard.dart';
import 'screens/organizer/create_tickets_screen.dart';
import './screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  // Setup server locator (existing authentication setup)
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
        '/organizer-dashboard': (context) => OrganizerDashboard(),
        '/create-tickets': (context) => CreateTicketsScreen(eventData: {}),
        //buy ticket nên là dạng pop-up sasa
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
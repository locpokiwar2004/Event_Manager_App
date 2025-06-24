import 'package:flutter/material.dart';
// import các screen bạn đã tạo
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/buy_a_ticket.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flower Shop App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12202F),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // khởi đầu ở màn hình Login
      initialRoute: '/checkout',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/checkout': (_) => const BuyATicket(),
      },
    );
  }
}

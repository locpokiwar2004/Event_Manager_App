import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Festrix'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/account');
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Music Festival 2025'),
            subtitle: const Text('June 20, 2025'),
            onTap: () {
              Navigator.pushNamed(context, '/event_detail');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Art Expo 2025'),
            subtitle: const Text('July 15, 2025'),
            onTap: () {
              Navigator.pushNamed(context, '/event_detail');
            },
          ),
        ],
      ),
    );
  }
}

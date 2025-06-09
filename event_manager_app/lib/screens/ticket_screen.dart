import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.confirmation_number),
            title: Text('Music Festival 2025'),
            subtitle: Text('Seat: A12'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.confirmation_number),
            title: Text('Art Expo 2025'),
            subtitle: Text('Seat: B7'),
          ),
        ],
      ),
    );
  }
}

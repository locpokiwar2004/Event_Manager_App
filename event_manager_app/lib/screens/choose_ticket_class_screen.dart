import 'package:flutter/material.dart';

class ChooseTicketClassScreen extends StatelessWidget {
  const ChooseTicketClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Ticket Class')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          ListTile(
            title: const Text('General Admission'),
            subtitle: const Text('\$50'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/enter_contact_info');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('VIP'),
            subtitle: const Text('\$120'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/enter_contact_info');
            },
          ),
        ],
      ),
    );
  }
}

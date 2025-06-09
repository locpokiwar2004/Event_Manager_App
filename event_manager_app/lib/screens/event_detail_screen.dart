import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Music Festival 2025',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Date: June 20, 2025'),
            const SizedBox(height: 8),
            const Text('Location: Central Park'),
            const SizedBox(height: 16),
            const Text(
              'Join us for an unforgettable experience with live performances from top artists.',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/choose_ticket_class');
              },
              child: const Text('Buy Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}

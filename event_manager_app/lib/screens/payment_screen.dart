import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Total: \$50', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(labelText: 'Card Number'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Expiry Date'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'CVV'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/checkout_complete');
              },
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}

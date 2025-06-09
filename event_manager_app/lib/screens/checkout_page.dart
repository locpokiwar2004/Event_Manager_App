// File: checkout_page.dart
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedClass = 'GA';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  int _quantity = 1;

  final List<Map<String, dynamic>> _ticketOptions = const [
    {'label': 'General Admission - GA', 'price': 100000, 'value': 'GA'},
    {'label': 'Priority / Early Access', 'price': 150000, 'value': 'PA'},
    {'label': 'VIP', 'price': 200000, 'value': 'VIP'},
    {'label': 'Super VIP', 'price': 300000, 'value': 'SVIP'},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var selectedOption = _ticketOptions.firstWhere((o) => o['value'] == _selectedClass);
    int price = selectedOption['price'] as int;
    int total = price * _quantity;

    return Scaffold(
      backgroundColor: const Color(0xBC1B1B1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6661A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Information
          RichText(
            text: TextSpan(
              text: 'Contact Information',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
              ),
              children: const [
                TextSpan(text: ' *', style: TextStyle(color: Color(0xFFFF3F00))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildInputField('Name', _nameController),
          const SizedBox(height: 8),
          _buildInputField('Phone number', _phoneController),
          const SizedBox(height: 8),
          _buildInputField('Email', _emailController),
          const SizedBox(height: 16),
          // Ticket Information
          Text(
            'Ticket Information',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Kalnia',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          // Ticket type and quantity row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ticket type', style: TextStyle(color: Colors.white.withAlpha(148), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Kalnia')),
              Text('Quantity', style: TextStyle(color: Colors.white.withAlpha(148), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Kalnia')),
            ],
          ),
          const SizedBox(height: 8),
          // Selected ticket and controls
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedOption['label'], style: const TextStyle(fontSize: 20, fontFamily: 'Kalnia', fontWeight: FontWeight.w700)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.white,
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Text('$_quantity', style: const TextStyle(fontSize: 20, fontFamily: 'Kalnia', fontWeight: FontWeight.w700, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: const Color(0xFFE6661A),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Price & Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimated', style: TextStyle(color: Colors.white.withAlpha(148), fontSize: 20, fontFamily: 'Kalnia', fontWeight: FontWeight.w700)),
              Text('$total đ', style: const TextStyle(color: Color(0xFFE6661A), fontSize: 20, fontFamily: 'Kalnia', fontWeight: FontWeight.w400)),
            ],
          ),
          const SizedBox(height: 24),
          // Continue button
          SizedBox(
            width: size.width,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6661A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Continue', style: TextStyle(fontFamily: 'Mallanna', fontWeight: FontWeight.w400, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black.withAlpha(148)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE6661A))),
      ),
    );
  }
}
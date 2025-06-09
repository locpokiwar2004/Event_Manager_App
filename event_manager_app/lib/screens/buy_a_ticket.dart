import 'package:flutter/material.dart';

class BuyATicket extends StatefulWidget {
  const BuyATicket({super.key});

  @override
  _BuyATicketState createState() => _BuyATicketState();
}

class _BuyATicketState extends State<BuyATicket> {
  String _selectedClass = 'GA';

  final List<Map<String, dynamic>> _ticketOptions = const [
    {'label': 'General Admission - GA', 'price': 100000, 'value': 'GA'},
    {'label': 'Priority / Early Access', 'price': 150000, 'value': 'PA'},
    {'label': 'VIP', 'price': 200000, 'value': 'VIP'},
    {'label': 'Super VIP', 'price': 300000, 'value': 'SVIP'},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                text: 'Choose your ticket class',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                ),
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Color(0xFFFF3F00)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _ticketOptions.length,
              itemBuilder: (context, index) {
                final option = _ticketOptions[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: _selectedClass == option['value']
                          ? const Color(0xFFE6661A)
                          : Colors.transparent,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: RadioListTile<String>(
                    value: option['value'] as String,
                    groupValue: _selectedClass,
                    onChanged: (val) {
                      setState(() {
                        _selectedClass = val!;
                      });
                    },
                    title: Text(
                      option['label'] as String,
                      style: const TextStyle(
                        fontFamily: 'Kalnia',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      '${option['price']} đ',
                      style: TextStyle(
                        fontFamily: 'Kalnia',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black.withAlpha(148),
                      ),
                    ),
                    activeColor: const Color(0xFFE6661A),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: size.width,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6661A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'Mallanna',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

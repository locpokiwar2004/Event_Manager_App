import 'package:flutter/material.dart';

class SystemPoliciesPage extends StatelessWidget {
  const SystemPoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7AA9ED), // Darker blue at top
              Color(0xFFBCFEFD), // Lighter teal/blue at bottom
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Back button
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Quay lại màn hình trước đó
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
              ),
            ),
            // Title
            const Positioned(
              top: 100,
  left: 0,
  right: 0,
  child: Align(
    alignment: Alignment.center,
    child: Text(
      "The system's policies",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    ),
              ),
            ),
            // Policies Content Area (White container with scrollable content)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2, // Bắt đầu từ 25% chiều cao màn hình
              left: 0,
              right: 0,
              bottom: 0, // Kéo dài xuống cuối màn hình
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20), // Thêm margin ngang
                width: 350,
                height: 1282,
                decoration: ShapeDecoration(
                  color: Colors.white, // Màu trắng của container chính sách
                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 100.0), // Padding cho nội dung
                  child: SingleChildScrollView( // Đảm bảo nội dung có thể cuộn
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Policies for Customers (Ticket Buyers)',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001C44),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildPolicySection(
                          title: '• Ticket Purchase & Confirmation:',
                          content:
                              'Upon successful payment, customers receive an e-ticket via email/SMS. It\'s the customer\'s responsibility to verify all ticket details immediately and report discrepancies within 24 hours. Keep your unique QR/barcode secure.',
                        ),
                        const SizedBox(height: 15),
                        _buildPolicySection(
                          title: '• Refund & Exchange Policy:',
                          content:
                              '• Event Cancellation: Full refunds will be issued within [Specific number of days, e.g., 7-15 business days] if an event is canceled by the organizer.\n'
                              '• Event Postponement: Customers can either use their ticket for the new date or request a refund.\n'
                              '• No Personal Refunds/Exchanges: Generally, no refunds or exchanges for personal reasons.\n'
                              '• Service Fees: Service fees (if any) may be non-refundable.',
                        ),
                        const SizedBox(height: 15),
                        _buildPolicySection(
                          title: '• Data Privacy:',
                          content: 'We protect personal information (name, phone, email, payment) according to our Privacy Policy, using it only for ticketing and service improvement. Information may be shared with event organizers for event management.',
                        ),
                        // Add more policy sections if needed to demonstrate scrolling
//
                        const Text(
                          'Policies for Event Organizers (Using the App to Sell Tickets)',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF001C44),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildPolicySection(
                          title: '• Account Registration & Activation:',
                          content:
                              'Organizers must provide accurate business/personal information for registration. We may require verification documents.',
                        ),
                                                const SizedBox(height: 15),
                        _buildPolicySection(
                          title: '• Initial Fees:',
                          content:
                              'A one-time activation fee is required to access the app organizing features (event management tools, sales page creation, initial tech support). Optional recurring maintenance fees may apply for advanced features. These fees cover development, maintenance, and support.',
                        ),
                                                const SizedBox(height: 15),
                        _buildPolicySection(
                          title: '• Service Fee Per Ticket:',
                          content:
                              'In addition to the initial fee, a commission (service fee) is charged on each ticket sold through our platform. The exact fee structure (percentage or fixed per ticket) will be outlined in your agreement, varying by event type, ticket volume, and chosen service package. Revenue (minus fees) is remitted according to the agreed payment cycle. Detailed sales reports will be provided.',
                        ),
                        // You can add more policy text here if you want to test scrolling
                        // Example: A very long paragraph to force scrolling
                        // const Text(
                        //   'This is an example of a very long paragraph to demonstrate that the SingleChildScrollView is working correctly. '
                        //   'You can add as much text here as you need, and the content will automatically become scrollable '
                        //   'if it overflows the screen height. Ensure your policies are comprehensive and clearly laid out for users. '
                        //   'This helps in building trust and provides a clear understanding of the terms and conditions. '
                        //   'Always make sure the language is easy to understand and legally compliant. '
                        //   'More text to make it even longer and test the scrolling functionality. '
                        //   'This allows users to read all the information without any issues, regardless of screen size. '
                        //   'Providing clear policies is crucial for any platform handling user data and transactions.',
                        //   style: TextStyle(fontSize: 14, color: Colors.black87),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // OK Button (fixed at the bottom)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // Chiều rộng của nút
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Quay lại màn hình trước đó
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6F89CF), // Màu xanh tím của nút OK
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm helper để xây dựng từng phần chính sách
  Widget _buildPolicySection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF001C44),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF001C44),
            height: 1.5, // Tăng khoảng cách dòng để dễ đọc hơn
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:quanlysukien/lib/login.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _code1Controller = TextEditingController();
  final TextEditingController _code2Controller = TextEditingController();
  final TextEditingController _code3Controller = TextEditingController();
  final TextEditingController _code4Controller = TextEditingController();

  // Focus nodes để điều khiển focus giữa các ô input
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  @override
  void dispose() {
    _code1Controller.dispose();
    _code2Controller.dispose();
    _code3Controller.dispose();
    _code4Controller.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

//gia lap code nhan duoc la 1234
  final String _correctCode='1234';
  void _verifyCode() {
    String fullCode = _code1Controller.text +
        _code2Controller.text +
        _code3Controller.text +
        _code4Controller.text;

    print('Entered Code: $fullCode');

    // Basic validation
    if (fullCode.length != _correctCode.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 4 digits!')),
      );
      return;
    }

    // Implement your code verification logic here
    // Example: call an API to verify the code
    if (fullCode == _correctCode) { // Giả lập mã đúng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code successful!')),
      );
      // Navigate to next screen (e.g., reset password or home)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code is incorrect. Please try again.')),
      );
    }
  }

  void _resendCode() {
    print('Resend Code tapped');
    // Implement logic to resend the verification code
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resending code...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Avoid overflow when keyboard appears
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3F5472), // Lighter blue at top
              Color(0xFFBCFEFD), // Darker blue at bottom
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
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
              ),
            ),
            // Main Content Area
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Thay thế CustomPaint bằng Image.asset
                    Image.asset(
                      'assets/images/a_verifeCode.png', // <-- Thay thế bằng đường dẫn đến ảnh của bạn
                      width: 250, // Điều chỉnh kích thước nếu cần
                      height: 180, // Điều chỉnh kích thước nếu cần
                      fit: BoxFit.contain, // Đảm bảo ảnh vừa vặn trong kích thước cho trước
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Verify Code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Code Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCodeInput(
                          controller: _code1Controller,
                          focusNode: _focusNode1,
                          nextFocusNode: _focusNode2,
                          isFirst: true,
                        ),
                        _buildCodeInput(
                          controller: _code2Controller,
                          focusNode: _focusNode2,
                          nextFocusNode: _focusNode3,
                          previousFocusNode: _focusNode1,
                        ),
                        _buildCodeInput(
                          controller: _code3Controller,
                          focusNode: _focusNode3,
                          nextFocusNode: _focusNode4,
                          previousFocusNode: _focusNode2,
                        ),
                        _buildCodeInput(
                          controller: _code4Controller,
                          focusNode: _focusNode4,
                          previousFocusNode: _focusNode3,
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Resend Code TextButton
                    TextButton(
                      onPressed: _resendCode,
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Confirm Button
                    _buildButton(
                      text: 'CONFIRM',
                      onPressed: _verifyCode,
                      color: const Color(0xFF3F5472), // Darker blue for button
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a single code input box
  Widget _buildCodeInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    FocusNode? previousFocusNode,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      width: 60,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFC7ECF2), // Light blue background for input box
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white54, width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        maxLength: 1, // Allow only one character
        decoration: const InputDecoration(
          counterText: "", // Hide the character counter
          border: InputBorder.none, // Remove default border
          contentPadding: EdgeInsets.zero, // Remove default padding
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Allow only digits
        ],
        onChanged: (value) {
          if (value.isNotEmpty && !isLast) {
            nextFocusNode?.requestFocus();
          } else if (value.isEmpty && !isFirst) {
            previousFocusNode?.requestFocus();
          }
          if (isLast && value.isNotEmpty) {
            // Khi ô cuối cùng được điền, ẩn bàn phím
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }

  // Hàm helper để xây dựng Button
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white54),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

// XÓA LỚP _VerificationImagePainter NÀY ĐI HOẶC BÌNH LUẬN LẠI
/*
class _VerificationImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // ... (code vẽ CustomPainter cũ)
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
*/
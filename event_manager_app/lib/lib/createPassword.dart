import 'package:flutter/material.dart';
import 'package:quanlysukien/lib/verifycode.dart';
//import 'package:quanlysukien/lib/login.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  //key quan ly trang thai cua form

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _confirmPassword() {

    // Implement your password creation logic here

        if (_formKey.currentState!.validate()){
      
    // Basic validation
    
    if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty || _phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all information!')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password and confirm password do not match!')),
      );
      return;
    }
    print('New Password: ${_newPasswordController.text}');
    print('Confirm Password: ${_confirmPasswordController.text}');
    print('Phone Number: ${_phoneNumberController.text}');


    // If validation passes, proceed to update password
    print('Password update logic goes here...');
    // Typically, you would send this data to an API
    // Then navigate to login or home screen
        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VerifyCodePage()),
    );
        }
        else{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password created successfully!')),
    );
        }
        
    // You might want to navigate back to the login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Tránh lỗi overflow khi bàn phím hiện lên, tuy nhiên cần cẩn thận nếu nội dung quá dài
      body: Container(
        decoration: const BoxDecoration(
          // Màu nền gradient hơi khác so với Login/Register
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001C44), // Darker blue at top
              Color(0xFF7AA9ED), // Lighter blue at bottom
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
            
            /*
            Positioned(
  top: 50,
  left: 20,
  child: Builder(
    builder: (BuildContext builderContext) { //bọc GestureDetector chứa nút Back bằng một Builder widget. Builder cung cấp một context mới là con trực tiếp của Scaffold.
      return GestureDetector(
        onTap: () {
          Navigator.of(builderContext).pop(); // Sử dụng context của Builder
        },
        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
      );
    },
  ),
),
*/

            // Main Content Area
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formKey,
                                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Thay thế CustomPaint bằng Image.asset
                      Image.asset(
                        'assets/images/newPass.png', // Đường dẫn đến ảnh của bạn
                        width: 265, // Kích thước của ảnh (điều chỉnh theo nhu cầu)
                        height: 275, // Kích thước của ảnh (điều chỉnh theo nhu cầu)
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Create new password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        // letterSpacing: 1, // Tùy chỉnh nếu cần
                      ),
                    ),
                    const SizedBox(height: 50),
                    // New Password Input
                    _buildTextField(
                      controller: _newPasswordController,
                      hintText: 'New Password',
                      isPassword: true,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password Input
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      isPassword: true,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter Password';
                            }
                            // Validator này chỉ kiểm tra rỗng. Việc so khớp sẽ làm trong _confirmPassword().
                            return null;
                          },
                    ),
                    const SizedBox(height: 20),
                    // Phone Number Input
                    _buildTextField(
                      controller: _phoneNumberController,
                      hintText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Phone Number';
                            }
                            // Bạn có thể thêm regex để kiểm tra định dạng số điện thoại
                            if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) { // Ví dụ 10-11 số
                              return 'Invalid phone number';
                            }
                            return null;
                          },
                    ),

                                        const SizedBox(height: 30), // Adjusted spacing
                    // Thin white line above the button
                    Container(
                      height: 1, // Height of the line
                      width: double.infinity, // Make the line span the width
                      color: Colors.white.withOpacity(0.5), // Color of the line (slightly transparent white)
                      margin: const EdgeInsets.only(bottom: 20), // Space between line and button
                    ),

                    const SizedBox(height: 50),
                    // Confirm Button
                    _buildButton(
                      text: 'CONFIRM',
                      onPressed: _confirmPassword,
                      color: const Color(0xFF7AA9ED), // Màu xanh tím của button

                    ),
                  ],
                ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm helper để xây dựng TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator, // <-- Thêm validator vào đây
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0), // Adjust padding for inner text
      decoration: BoxDecoration(
        color: const Color(0xFF7AA9ED), // Màu nền của input field
        borderRadius: BorderRadius.circular(10), // Bo tròn góc
        border: Border.all(color: Colors.white, width: 1.5),  //thêm viền trắng
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none, // Bỏ border mặc định
          contentPadding: const EdgeInsets.symmetric(vertical: 18), // Điều chỉnh padding theo chiều dọc
          errorBorder: const UnderlineInputBorder( // <-- Thêm errorBorder để hiển thị lỗi
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: const UnderlineInputBorder( // <-- Thêm focusedErrorBorder
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        cursorColor: Colors.white,
       validator: validator, // <-- Gán validator ở đây
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
            borderRadius: BorderRadius.circular(10), // Bo tròn góc

            side: const BorderSide(color: Colors.white, width: 1.5), //vien trang
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
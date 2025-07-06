import 'package:flutter/material.dart';
import 'package:quanlysukien/lib/systempolicies.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //key quan ly trang thai cua form
  final _formKey = GlobalKey<FormState>();
  // Controllers cho các trường nhập liệu
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController = TextEditingController();

  // Biến trạng thái cho checkbox
  bool _agreeToPolicies = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _reenterPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    // Logic xử lý đăng ký ở đây
    // 1. Kiểm tra tất cả các trường trong Form bằng validator
    if (_formKey.currentState!.validate()) {
      // 2. Nếu Form hợp lệ (không có trường nào trống và các validator khác pass)
      // Tiếp tục kiểm tra các điều kiện đặc biệt khác
      if (_passwordController.text != _reenterPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Re-entered password does not match!')),
        );
        return;
      }
      if (!_agreeToPolicies) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must agree to the system policies!')),
        );
        return;
      }

    print('Full Name: ${_fullNameController.text}');
    print('Email: ${_emailController.text}');
    print('Phone Number: ${_phoneNumberController.text}');
    print('Address: ${_addressController.text}');
    print('Password: ${_passwordController.text}');
    print('Re-enter Password: ${_reenterPasswordController.text}');
    print('Agreed to policies: $_agreeToPolicies');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Thường thì sau khi đăng ký thành công sẽ chuyển hướng về trang Login
      // Navigator.pop(context); // Hoặc Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      // Nếu có trường nào đó không hợp lệ (validator trả về lỗi)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields completely and accurately.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Tránh lỗi overflow khi bàn phím hiện lên
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C5776), // Màu xanh đậm hơn ở trên
              Color(0xFF2C99AE), // Màu xanh nhạt hơn ở dưới
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Header (Back button, REGISTER text, description)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,//thay doi vi tri sang center
                    children: [
                      //van giu button back ben trai
                      Align(
                        alignment: Alignment.centerLeft,
                        child:                       GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Quay lại màn hình trước
                        },
                      
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                      ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'REGISTER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Create an account to book tickets\nor organize events',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Main content (input fields and button)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35, // Điều chỉnh vị trí của phần trắng
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                  child: Form( // <-- Bao bọc tất cả các TextFormField bằng Form
                  key: _formKey, //<-- Gán GlobalKey cho Form
                  child: Column(
                    children: <Widget>[
                      // Full Name Input
                      _buildTextField(
                        controller: _fullNameController,
                        hintText: 'Full Name',
                        icon: Icons.person_outline,
                        validator: (value){
                          if (value==null||value.isEmpty){
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Email Input
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if (value==null||value.isEmpty){
                            return 'Please enter your Email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                          {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Phone Number Input
                      _buildTextField(
                        controller: _phoneNumberController,
                        hintText: 'Phone Number',
                        icon: Icons.phone_outlined,
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
                      const SizedBox(height: 20),
                      // Address Input
                      _buildTextField(
                        controller: _addressController,
                        hintText: 'Address',
                        icon: Icons.question_mark_outlined, // Dùng tạm icon này
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Address';
                            }
                            return null;
                          },
                      ),
                      const SizedBox(height: 20),
                      // Password Input
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
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
                      // Re-enter Password Input
                      _buildTextField(
                        controller: _reenterPasswordController,
                        hintText: 'Re-enter Password',
                        icon: Icons.chat_bubble_outline, // Dùng icon này theo hình
                        isPassword: true,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter Password';
                            }
                            // Validator này chỉ kiểm tra rỗng. Việc so khớp sẽ làm trong _register().
                            return null;
                          },
                      ),
                      const SizedBox(height: 20),
                      // Agree to policies checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeToPolicies,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _agreeToPolicies = newValue!;
                              });
                            },
                            activeColor: const Color(0xFF2E7D8A), // Màu xanh của nền gradient
                            checkColor: Colors.white,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Mở trang chính sách của hệ thống
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SystemPoliciesPage()),
                                  );
                                print('Navigate to System Policies');
                              },
                              child: const Text(
                                'Agree to the system\'s policies',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3F5472),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Register Button
                      _buildButton(
                        text: 'REGISTER',
                        onPressed: _register,
                        color: const Color(0xFF0C5776), // Màu xanh đậm hơn
                      ),
                    ],
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
 // Hàm helper để xây dựng các trường nhập liệu
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator, // <-- Thêm validator vào đây
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField( // <-- Thay TextField bằng TextFormField
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black87, fontSize: 18),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF0C5776)),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0C5776), width: 2),
          ),
          errorBorder: const UnderlineInputBorder( // <-- Thêm errorBorder để hiển thị lỗi
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: const UnderlineInputBorder( // <-- Thêm focusedErrorBorder
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
          isDense: true,
        ),
        cursorColor: const Color(0xFF0C5776),
        validator: validator, // <-- Gán validator ở đây
      ),
    );
  }
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
            borderRadius: BorderRadius.circular(30),
            // Không có border cho button như hình
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
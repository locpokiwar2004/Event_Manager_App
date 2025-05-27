import 'package:flutter/material.dart';
import 'package:quanlysukien/lib/register.dart';
import 'package:quanlysukien/lib/createPassword.dart';
//import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //key quan ly trang thai cho form
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  //CSDL gia lap
  final String _correctEmail = 'giang@gmail.com';
  final String _correctPassword = 'giangne';

  //logic xu ly
void _handleLogin() {
    // 1. Kiểm tra xem Form có hợp lệ không (dựa trên các validator của TextFormField)
    if (_formKey.currentState!.validate()) {
      // 2. Nếu Form hợp lệ (không có trường nào trống và các validator khác pass)
      String enteredEmail = _emailController.text;
      String enteredPassword = _passwordController.text;

      // 3. Logic xác thực mật khẩu với "CSDL" giả lập
      if (enteredEmail == _correctEmail && enteredPassword == _correctPassword) {
        // Đăng nhập thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        // Chuyển hướng đến trang Home hoặc Dashboard
        // Ví dụ: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        // Mật khẩu hoặc email không đúng
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect email or password')),
        );
      }
    } else {
      // Nếu có trường nào đó không hợp lệ (validator trả về lỗi)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the information completely and accurately')),
      );
    }
        // gọi API, điều hướng đến màn hình chính
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
/*
  void _login() {
    // Triển khai logic đăng nhập
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    // gọi API, điều hướng đến màn hình chính
  }
*/

//dieu huong qua  trang register
  void _register() {
    // Trien khai logic dang ky
    print('Navigate to Register page');
    Navigator.push(context, //day Route moi len stack
    MaterialPageRoute(builder: (context)=> const RegisterPage()),);
    //chuyen doi toan man hinh
  }
//dieu huong qua create new password
    void _forgotPassword() {
    print('Navigating to Create New Password page');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001C44), // Darker teal/blue at top
              Color(0xFF2C99AE), // Lighter teal/blue at bottom
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0), child: Form(
//bao boc bang Form
             key: _formKey, // <-- Gán GlobalKey cho Form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Placeholder cho phan logo/avatar
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Light grey as in the image
                    shape: BoxShape.circle,
                  ),
                  // Bạn có thể thay thế bằng hình ảnh thực tế:
                  // child: Image.asset('assets/your_logo.png'),
                ),
                const SizedBox(height: 50),
                const Text(
                  'LOGIN',
                 style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2, // Adjust letter spacing to match
                  ),
                ),
                const SizedBox(height: 50),
                // Email Input
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      // Thêm kiểm tra định dạng email nếu cần
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  
                ),
                const SizedBox(height: 20),
                // Password Input
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock, // Sử dụng biểu tượng khóa thay vì bong bóng trò chuyện để nhập mật khẩu
                  isPassword: true,
                  
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Passsword';
                      }
                      // Thêm kiểm tra độ dài mật khẩu nếu cần
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    
                ),
                const SizedBox(height: 10),
                // Forgot Password
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword, // Gọi hàm _forgotPassword để chuyển trang
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Login Button
                _buildButton(
                  text: 'LOGIN',
                  //goi ham xu ly dang nhap
                  onPressed:  _handleLogin, // <-- Gọi hàm _handleLogin đã tùy chỉnh
                  color: const Color(0xFF001C44), // Darker blue for button
                ),
                const SizedBox(height: 30),
                // OR Separator
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Divider(
                        color: Colors.white54,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.white54,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Register Button
                _buildButton(
                  text: 'REGISTER',
                  onPressed: _register,
                  color: const Color(0xFF001C44), // Darker blue for button
                ),
              ],
            ),
          ),
        ),
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
        color: Colors.white.withOpacity(0.2), // Semi-transparent white background for input fields
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white54), // Subtle border
      ),
      child: TextFormField( // <-- Thay TextField bằng TextFormField
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none, // Remove default underline
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 14), // Màu lỗi dễ nhìn trên nền tối
          errorBorder: OutlineInputBorder( // <-- Thêm errorBorder
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder( // <-- Thêm focusedErrorBorder
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        cursorColor: Colors.white,
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
      width: double.infinity, // Make button full width
      height: 60, // Set fixed height for buttons
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white54), // Subtle white border for buttons
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
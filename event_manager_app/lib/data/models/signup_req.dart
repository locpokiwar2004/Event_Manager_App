class SignupReqParams {
  final String email;
  final String Password;  // Backend expects "Password"
  final String FullName;  // Backend expects "FullName"

  SignupReqParams({
    required this.email,
    required this.Password,
    required this.FullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'Password': Password,
      'FullName': FullName,
    };
  }
}
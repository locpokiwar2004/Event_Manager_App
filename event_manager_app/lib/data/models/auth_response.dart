class AuthResponse {
  final String? token;
  final String? message;
  final UserData? user;

  AuthResponse({
    this.token,
    this.message,
    this.user,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      token: map['token'],
      message: map['message'],
      user: map['user'] != null ? UserData.fromMap(map['user']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'message': message,
      'user': user?.toMap(),
    };
  }
}

class UserData {
  final int? id;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? birthDate;

  UserData({
    this.id,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.birthDate,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'],
      email: map['email'],
      fullName: map['fullName'] ?? map['full_name'],
      phoneNumber: map['phoneNumber'] ?? map['phone_number'],
      birthDate: map['birthDate'] ?? map['birth_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
    };
  }
}

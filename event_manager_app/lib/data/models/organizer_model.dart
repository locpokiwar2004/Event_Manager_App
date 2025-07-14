import 'package:event_manager_app/domain/entities/event.dart';

class OrganizerModel {
  final int userId;
  final String fullName;
  final String email;
  final String? phone;
  final String? address;

  OrganizerModel({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phone,
    this.address,
  });

  factory OrganizerModel.fromJson(Map<String, dynamic> json) {
    return OrganizerModel(
      userId: json['user_id'] ?? json['id'],
      fullName: json['full_name'] ?? json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  OrganizerEntity toEntity() {
    return OrganizerEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phone: phone,
      address: address,
    );
  }

  factory OrganizerModel.fromEntity(OrganizerEntity entity) {
    return OrganizerModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
    );
  }
}

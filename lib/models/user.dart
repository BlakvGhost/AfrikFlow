import 'package:afrik_flow/models/country.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final bool isAdmin;
  final bool isActive;
  final bool isVerified;
  final String? token;
  final String? avatar;
  final String? legalDoc;
  final bool isTwoFactorEnabled;
  final Country country;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.isAdmin,
    required this.isActive,
    required this.isVerified,
    required this.token,
    this.avatar,
    this.legalDoc,
    required this.isTwoFactorEnabled,
    required this.country,
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    bool? isAdmin,
    bool? isActive,
    bool? isVerified,
    String? token,
    String? avatar,
    String? legalDoc,
    Country? country,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      token: token ?? this.token,
      avatar: avatar ?? this.avatar,
      legalDoc: legalDoc ?? this.legalDoc,
      country: country ?? this.country,
      isTwoFactorEnabled: isTwoFactorEnabled,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_num'],
      isAdmin: json['is_admin'] == 1,
      isActive: json['is_active'] == 1,
      isVerified: json['is_verified'] == 1,
      token: json['token'],
      avatar: json['avatar'],
      legalDoc: json['legal_doc'],
      isTwoFactorEnabled: json['is_2fa_active'] == 1,
      country: Country.fromJson(json['country']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_num': phoneNumber,
      'is_admin': isAdmin ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'is_verified': isVerified ? 1 : 0,
      'token': token,
      'avatar': avatar,
      'legal_doc': legalDoc,
      'is_2fa_active': isTwoFactorEnabled,
      'country': country.toJson(),
    };
  }
}

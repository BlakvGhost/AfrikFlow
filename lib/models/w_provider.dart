import 'package:afrik_flow/models/country.dart';

class WProvider {
  final int id;
  final String name;
  final String withdrawMode;
  final String sendingMode;
  final String logo;
  final String fpayName;
  final Country country;

  WProvider({
    required this.id,
    required this.name,
    required this.withdrawMode,
    required this.sendingMode,
    required this.logo,
    required this.fpayName,
    required this.country,
  });

  factory WProvider.fromJson(Map<String, dynamic> json) {
    return WProvider(
      id: json['id'],
      name: json['name'] ?? '',
      withdrawMode: json['withdraw_mode'] ?? '',
      sendingMode: json['sending_mode'] ?? '',
      logo: json['logo'] ?? '',
      fpayName: json['fpay_name'] ?? '',
      country: Country.fromJson(json['country'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'withdraw_mode': withdrawMode,
      'sending_mode': sendingMode,
      'logo': logo,
      'fpay_name': fpayName,
      'country': country.toJson(),
    };
  }
}

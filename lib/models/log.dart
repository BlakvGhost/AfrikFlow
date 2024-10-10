class Log {
  String action;
  String ipAddress;
  String userAgent;
  String ipDetails;
  String city;

  Log({
    required this.action,
    required this.ipAddress,
    required this.userAgent,
    required this.ipDetails,
    required this.city,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      action: json['action'],
      ipAddress: json['ip_address'],
      userAgent: json['user_agent'],
      ipDetails: json['ip_details'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'ip_details': ipDetails,
      'city': city,
    };
  }
}

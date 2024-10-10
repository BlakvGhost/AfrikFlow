class Log {
  String action;
  String ipAddress;
  String userAgent;
  String city;
  String createdAt;
  String humarizeDate;

  Log({
    required this.action,
    required this.ipAddress,
    required this.userAgent,
    required this.city,
    required this.createdAt,
    required this.humarizeDate,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      action: json['action'],
      ipAddress: json['ip_address'],
      userAgent: json['user_agent'],
      humarizeDate: json['humarizeDate'],
      createdAt: json['created_at'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'created_at': createdAt,
      'humarizeDate': humarizeDate,
      'city': city,
    };
  }
}

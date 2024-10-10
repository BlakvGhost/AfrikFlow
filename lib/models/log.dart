class Log {
  String action;
  String ipAddress;
  String userAgent;
  String ipDetails;
  String city;
  String createdAt;
  String humarizeDate;

  Log({
    required this.action,
    required this.ipAddress,
    required this.userAgent,
    required this.ipDetails,
    required this.city,
    required this.createdAt,
    required this.humarizeDate,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      action: json['action'],
      ipAddress: json['ip_address'],
      userAgent: json['user_agent'],
      ipDetails: json['ip_details'],
      humarizeDate: json['humarizeDate'],
      createdAt: json['createdAt'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'ip_details': ipDetails,
      'createdAt': createdAt,
      'humarizeDate': humarizeDate,
      'city': city,
    };
  }
}

class Kyc {
  String legalDoc;
  String? failureReason;
  String status;

  Kyc({
    required this.legalDoc,
    this.failureReason,
    required this.status,
  });

  factory Kyc.fromJson(Map<String, dynamic> json) {
    return Kyc(
      legalDoc: json['legal_doc'],
      failureReason: json['failure_reason'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'legal_doc': legalDoc,
      'failure_reason': failureReason,
      'status': status,
    };
  }
}

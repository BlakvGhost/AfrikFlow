class Kyc {
  String legalDoc;
  String? failureReason;
  String status;
  String? selfieImage;
  int? failedStep;
  String id;

  Kyc({
    required this.legalDoc,
    this.failureReason,
    required this.status,
    this.selfieImage,
    this.failedStep,
    required this.id,
  });

  factory Kyc.fromJson(Map<String, dynamic> json) {
    return Kyc(
      legalDoc: json['legal_doc'],
      failureReason: json['failure_reason'],
      status: json['status'],
      selfieImage: json['selfie_image'],
      failedStep: json['failed_step'] != null
          ? int.parse(json['failed_step'].toString())
          : null,
      id: json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'legal_doc': legalDoc,
      'failure_reason': failureReason,
      'status': status,
      'selfie_image': selfieImage,
      'failed_step': failedStep?.toString(),
      'id': id,
    };
  }
}

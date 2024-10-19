class Kyc {
  String legalDoc;
  String? failureReason;
  String status;
  String? selfieImage;
  String? failedStep;

  Kyc({
    required this.legalDoc,
    this.failureReason,
    required this.status,
    this.selfieImage,
    this.failedStep,
  });

  factory Kyc.fromJson(Map<String, dynamic> json) {
    return Kyc(
      legalDoc: json['legal_doc'],
      failureReason: json['failure_reason'],
      status: json['status'],
      selfieImage: json['selfie_image'],
      failedStep: json['failed_step'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'legal_doc': legalDoc,
      'failure_reason': failureReason,
      'status': status,
      'selfie_image': selfieImage,
      'failed_step': failedStep,
    };
  }
}

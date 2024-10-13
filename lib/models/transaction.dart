import 'package:afrik_flow/models/w_provider.dart';

class Transaction {
  final int id;
  final String payinPhoneNumber;
  final WProvider payinWProvider;
  final String payinStatus;
  final String? payoutPhoneNumber;
  final WProvider payoutWProvider;
  final String payoutStatus;
  final double amount;
  final double amountWithoutFees;
  final String type;
  final String token;
  final String? disburseToken;
  final String? otpCode;
  final Receiver receiver;
  final String mode;
  final DateTime createdAt;
  final String humarizeDate;
  final String? invoiceUrl;

  Transaction({
    required this.id,
    required this.payinPhoneNumber,
    required this.payinWProvider,
    required this.payinStatus,
    this.payoutPhoneNumber,
    required this.payoutWProvider,
    required this.payoutStatus,
    required this.amount,
    required this.amountWithoutFees,
    required this.type,
    required this.token,
    this.disburseToken,
    this.otpCode,
    required this.receiver,
    required this.mode,
    required this.createdAt,
    required this.humarizeDate,
    this.invoiceUrl,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      payinPhoneNumber: json['payin_phone_number'],
      payinWProvider: WProvider.fromJson(json['payin_wprovider']),
      payinStatus: json['payin_status'],
      payoutPhoneNumber: json['payout_phone_number'],
      payoutWProvider: WProvider.fromJson(json['payout_wprovider']),
      payoutStatus: json['payout_status'],
      amount: json['amount'].toDouble(),
      amountWithoutFees: json['amountWithoutFees'].toDouble(),
      type: json['type'],
      token: json['token'],
      disburseToken: json['disburse_token'],
      otpCode: json['otp_code'],
      receiver: Receiver.fromJson(json['receiver']),
      mode: json['mode'],
      createdAt: DateTime.parse(json['created_at']),
      humarizeDate: json['humarizeDate'],
      invoiceUrl: json['invoice_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payin_phone_number': payinPhoneNumber,
      'payin_wprovider': payinWProvider.toJson(),
      'payin_status': payinStatus,
      'payout_phone_number': payoutPhoneNumber,
      'payout_wprovider': payoutWProvider.toJson(),
      'payout_status': payoutStatus,
      'amount': amount,
      'amountWithoutFees': amountWithoutFees,
      'type': type,
      'token': token,
      'disburse_token': disburseToken,
      'otp_code': otpCode,
      'receiver': receiver.toJson(),
      'mode': mode,
      'created_at': createdAt.toIso8601String(),
      'humarizeDate': humarizeDate,
      'invoice_url': invoiceUrl,
    };
  }
}

class Receiver {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? address;

  Receiver({
    this.firstName,
    this.lastName,
    this.email,
    this.address,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'address': address,
    };
  }
}

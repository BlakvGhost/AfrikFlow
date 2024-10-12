// ignore_for_file: constant_identifier_names

import 'package:afrik_flow/models/transaction.dart';

class Notification {
  final int id;
  final String type;
  final String message;
  final bool isRead;
  final Transaction? transaction;
  final DateTime createdAt;
  final String humarizeDate;

  Notification({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    this.transaction,
    required this.createdAt,
    required this.humarizeDate,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      type: json['type'],
      message: json['message'],
      isRead: json['isRead'] == 1,
      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      humarizeDate: json['humarizeDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'isRead': isRead ? 1 : 0,
      'transaction': transaction?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'humarizeDate': humarizeDate,
    };
  }

  static const String PROMOTION = 'promotion';
  static const String INFO = 'info';
  static const String ALERT = 'alert';
  static const String WELCOME = 'welcome';
  static const String TRANSFERT = 'transfert';
}

import 'package:afrik_flow/models/transaction.dart';
import 'package:afrik_flow/models/w_provider.dart';
import 'package:afrik_flow/providers/api_client_provider.dart';
import 'package:afrik_flow/services/api_client.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class TransactionService {
  final WidgetRef ref;
  late final ApiClient apiClient;

  TransactionService({required this.ref}) {
    apiClient = ref.read(apiClientProvider);
  }

  Future<Map<String, dynamic>> sendTransaction(Transaction transaction) async {
    final url = Uri.parse('$apiBaseUrl/transactions/send');

    final response = await apiClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)['data']};
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      return {'success': false, 'message': errorMessage};
    }
  }

  Future<List<Transaction>> listTransactions() async {
    final url = Uri.parse('$apiBaseUrl/transactions');

    final response = await apiClient.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body)['data'];
      return jsonResponse.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<List<WProvider>> listWalletProviders() async {
    final url = Uri.parse('$apiBaseUrl/wallet-providers');

    final response = await apiClient.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body)['data'];
      return jsonResponse.map((json) => WProvider.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Wallet Providers');
    }
  }
}
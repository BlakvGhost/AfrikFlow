import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:afrik_flow/services/api_client.dart';
import 'package:afrik_flow/providers/user_notifier.dart';
import 'package:http/http.dart' as http;


final apiClientProvider = Provider<ApiClient>((ref) {
  final user = ref.watch(userProvider);
  return ApiClient(http.Client(), user);
});

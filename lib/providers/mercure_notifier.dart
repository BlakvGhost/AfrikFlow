import 'package:afrik_flow/utils/global_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MercureNotifier extends StateNotifier<List<String>> {
  MercureNotifier() : super([]) {
    _subscribeToMercure();
  }

  void _subscribeToMercure() async {
    var url = Uri.parse(mercureHub);

    var request = http.Request('GET', url);
    request.headers.addAll({
      'Authorization': 'Bearer $mercureJwt',
      'Accept': 'text/event-stream',
    });

    var response = await http.Client().send(request);

    response.stream.transform(utf8.decoder).listen((event) {
      var data = jsonDecode(event);
      String eventMessage = data['message'] ?? 'Nouvel événement Mercure';

      print('Event received: $eventMessage');
    });
  }
}

final mercureProvider =
    StateNotifierProvider<MercureNotifier, List<String>>((ref) {
  return MercureNotifier();
});

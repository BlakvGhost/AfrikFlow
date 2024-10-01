import 'package:afrik_flow/models/country.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<List<Country>> fetchCountries() async {
    final url = Uri.parse('$apiBaseUrl/countries');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body)['data'];
      return jsonList.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }
}

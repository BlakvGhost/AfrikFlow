import 'package:afrik_flow/models/country.dart';
import 'package:afrik_flow/utils/global_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<CountriesResponse> fetchCountries() async {
    final url = Uri.parse('$apiBaseUrl/countries');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final countriesData = jsonResponse['data'];

      return CountriesResponse.fromJson(countriesData);
    } else {
      throw Exception('Failed to load countries');
    }
  }
}

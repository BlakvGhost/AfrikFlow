import 'package:http/http.dart' as http;
import 'package:afrik_flow/models/user.dart';

class ApiClient extends http.BaseClient {
  final http.Client _inner;
  final User? _user;

  ApiClient(this._inner, this._user);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Content-Type'] = "application/json";

    if (_user != null) {
      request.headers['Authorization'] = 'Bearer ${_user.token}';
    }
    return _inner.send(request);
  }
}

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

class HttpRequestProcessor {

  static const int defaultTimeout = 10;
  final String _rootUrl;
  late final Client _client;

  HttpRequestProcessor(this._rootUrl, { Client? httpClient }) {
    _client = httpClient ?? Client();
  }

  String getRootUrl() => _rootUrl;

  Uri formatGetUrl(String path, { Map<String, String> parameters = const {} }) {
    final parameterString = parameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final fullPath = '${getRootUrl()}$path${parameterString.isNotEmpty
        ? "?$parameterString"
        : ""}';
    return Uri.parse(Uri.encodeFull(fullPath));
  }

  Future<http.Response> fetch(Uri requestUri,
      {int timeout = defaultTimeout}) async {
    final response = await _client.get(requestUri).timeout(
        Duration(seconds: timeout));
    return response;
  }
}

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:simple_reddit_fetcher/repository/http_request_processor.dart';


@GenerateMocks([http.Client])
void main() {
  group('getRootUrl', () {
    test('String when init', () {
      const url = 'const';
      final httpRequestProcessor = HttpRequestProcessor(url);
      expect(httpRequestProcessor.getRootUrl(), url);
    });

    test('Empty String when init', () {
      const url = '';
      final httpRequestProcessor = HttpRequestProcessor(url);
      expect(httpRequestProcessor.getRootUrl(), url);
    });
  });

  group('formatGetUrl', () {
    test('without parameter', () {
      const url = 'https://www.google.com';
      const path = "/123";
      final expectedUrl = Uri.parse('$url$path');
      final httpRequestProcessor = HttpRequestProcessor(url);
      expect(httpRequestProcessor.formatGetUrl(path), expectedUrl);
    });

    test('without parameter with non-sense path', () {
      const url = 'https://www.google.com';
      const path = 'fjdskalf 90r32 86%^';
      final expectedUrl = Uri.parse('$url$path');
      final httpRequestProcessor = HttpRequestProcessor(url);
      expect(httpRequestProcessor.formatGetUrl(path), expectedUrl);
    });

    test('with empty parameter', () {
      const url = 'https://www.google.com';
      const path = "/123";
      final expectedUrl = Uri.parse('$url$path');
      final httpRequestProcessor = HttpRequestProcessor(url);
      expect(httpRequestProcessor.formatGetUrl(path, parameters: const {}),
          expectedUrl);
    });

    test('with parameter', () {
      const url = 'https://www.google.com';
      const path = "/123";
      const parameters = <String, String>{
        '456': '789',
        'qw e': 'er t',
      };
      const parameterString = '456=789&qw%20e=er%20t';
      final expectedUrl = Uri.parse('$url$path?$parameterString');
      final httpRequestProcessor = HttpRequestProcessor(url);
      expect(httpRequestProcessor.formatGetUrl(path, parameters: parameters),
          expectedUrl);
    });
  });

  group('fetch', () {
    test('success', () async {
      final client = MockClient((request) async {
        return Response('', 200);
      });

      const url = 'https://www.google.com';
      final httpRequestProcessor = HttpRequestProcessor(
          url, httpClient: client);
      final response = await httpRequestProcessor.fetch(
          httpRequestProcessor.formatGetUrl(''));
      expect(response.statusCode, 200);
    });

    test('fail', () async {
      final client = MockClient((request) async {
        return Response('', 404);
      });

      const url = 'https://www.google.com';
      final httpRequestProcessor = HttpRequestProcessor(
          url, httpClient: client);
      final response = await httpRequestProcessor.fetch(
          httpRequestProcessor.formatGetUrl(''));
      expect(response.statusCode, 404);
    });

    test('timeout', () {
      fakeAsync((async) {
        const url = 'https://www.google.com';
        final httpRequestProcessor = HttpRequestProcessor(url);
        expect(
            httpRequestProcessor.fetch(httpRequestProcessor.formatGetUrl('')),
            throwsA(isA<TimeoutException>()));

        async.elapse(Duration(
            seconds: (HttpRequestProcessor.defaultTimeout * 2).round()));
      });
    });
  });
}

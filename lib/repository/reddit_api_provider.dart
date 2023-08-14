import 'dart:async';

import 'package:http/http.dart';
import 'package:http_status_code/http_status_code.dart';

import '../model/reddit_post.dart';
import 'http_request_processor.dart';

class RedditApiProvider extends HttpRequestProcessor {
  RedditApiProvider({Client? httpClient})
      : super('https://www.reddit.com', httpClient: httpClient);

  Future<PostListResponse> getPost({int limit = 10, String? after}) async {
    if (limit <= 0) {
      throw const RedditApiProviderInvalidParameterException('limit must > 0');
    }
    final url = formatGetUrl('/r/technology/new.json', parameters: {
      'limit': '$limit',
      'after': after ?? '',
    });
    try {
      final response = await fetch(url);
      if (response.statusCode == StatusCode.OK) {
        final postListResponse = PostListResponse.fromJson(
            response.body, response.request?.url.host ?? getRootUrl());
        return postListResponse;
      } else {
        throw RedditApiProviderNetworkException(response.statusCode,
            reason: response.body);
      }
    } on TimeoutException {
      rethrow;
    } on TypeError {
      rethrow;
    } on FormatException {
      rethrow;
    }
  }
}

class RedditApiProviderInvalidParameterException implements Exception {
  final String reason;

  const RedditApiProviderInvalidParameterException(this.reason);

  @override
  String toString() => '[$runtimeType] $reason';
}

class RedditApiProviderNetworkException implements Exception {
  final int statusCode;
  final String? reason;

  const RedditApiProviderNetworkException(this.statusCode, {this.reason});

  @override
  String toString() => reason != null
      ? '[$runtimeType] $statusCode: $reason'
      : '[$runtimeType] $statusCode';
}

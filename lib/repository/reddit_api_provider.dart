import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:http/http.dart';
import 'package:http_status_code/http_status_code.dart';

import '../model/reddit_post.dart';
import 'http_request_processor.dart';

class RedditApiProvider extends HttpRequestProcessor {
  RedditApiProvider({Client? httpClient})
      : super('https://www.reddit.com', httpClient: httpClient);

  Future<Either<Exception, PostListResponse>> getPost(
      {int limit = 10, String? after}) async {
    if (limit <= 0) {
      return const Left(
          RedditApiProviderInvalidParameterException('limit must > 0'));
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
        return Right(postListResponse);
      } else {
        return Left(RedditApiProviderNetworkException(response.statusCode,
            reason: response.body));
      }
    } on TimeoutException catch (e) {
      return Left(e);
    } on TypeError catch (e) {
      return Left(FormatException(e.toString()));
    } on FormatException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
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

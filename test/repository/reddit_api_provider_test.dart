import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:http_status_code/http_status_code.dart';
import 'package:simple_reddit_fetcher/repository/reddit_api_provider.dart';

void main() {
  group('getPost', () {
    group('200', () {
      test('correct sample json', () async {
        const kind = 'listing';
        const after = 'qwer';
        const before = 'asdf';
        const length = 2;
        const rootUrl = 'https://www.reddit.com';
        const id = '12345';
        const author = '23456';
        const title = '34567 title';
        const thumbnailHeight = 12;
        const thumbnailWeight = 34;
        const thumbnail = 'https://123.com/456.jpg';
        const permalink = '/567/890/';
        const date = 1691741421.0;
        final client = MockClient((request) async {
          const sampleDataString = '{"kind": "$kind", "data": '
              '{"after": "$after",'
              '"before": "$before",'
              '"dist": $length,'
              '"children": [{"data":{'
              '"author_fullname":"$author",'
              '"title":"$title",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}, {"data":{'
              '"author_fullname":"$author 2",'
              '"title":"$title 2",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}]}}';
          return Response(sampleDataString, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        final dataResponse = await redditApiProvider.getPost();
        expect(dataResponse.isRight, true);
        expect(dataResponse.right.kind, kind);
        final dataList = dataResponse.right.data;
        expect(dataList.after, after);
        expect(dataList.before, before);
        expect(dataList.dataList.length, length);
        final data = dataList.dataList[0];
        expect(data.id, id);
        expect(data.title, title);
        expect(data.authorFullName, author);
        expect(data.thumbnail, Uri.parse(thumbnail));
        expect(data.thumbnailHeight, thumbnailHeight);
        expect(data.thumbnailWidth, thumbnailWeight);
        expect(data.permalink, Uri.parse('$rootUrl$permalink'));
        expect(
            data.createdDateTime,
            DateTime.fromMillisecondsSinceEpoch((date * 1000).round(),
                isUtc: true));
      });

      test('correct json', () async {
        const kind = 'Listing';
        const after = 't3_15qq74z';
        const String? before = null;
        const length = 1;
        const rootUrl = 'https://www.reddit.com';
        const id = '15qq74z';
        const author = 't2_2uwit82z';
        const title =
            'Overwatch 2 is the worst game on Steam, according to user reviews | "The people who make Overwatch porn work harder than the people who make Overwatch"';
        const thumbnailHeight = 78;
        const thumbnailWeight = 140;
        const thumbnail =
            'https://b.thumbs.redditmedia.com/JCQwUcQ5ExhV7KuPPyUH8N297eY6N93fnPqilxxkelE.jpg';
        const permalink =
            '/r/technology/comments/15qq74z/overwatch_2_is_the_worst_game_on_steam_according/';
        const date = 1692006707.0;
        final client = MockClient((request) async {
          const realDataBase64 =
              'eyJraW5kIjoiTGlzdGluZyIsImRhdGEiOnsiYWZ0ZXIiOiJ0M18xNXFxNzR6IiwiZGlzdCI6MSwibW9kaGFzaCI6IiIsImdlb19maWx0ZXIiOiIiLCJjaGlsZHJlbiI6W3sia2luZCI6InQzIiwiZGF0YSI6eyJhcHByb3ZlZF9hdF91dGMiOm51bGwsInN1YnJlZGRpdCI6InRlY2hub2xvZ3kiLCJzZWxmdGV4dCI6IiIsImF1dGhvcl9mdWxsbmFtZSI6InQyXzJ1d2l0ODJ6Iiwic2F2ZWQiOmZhbHNlLCJtb2RfcmVhc29uX3RpdGxlIjpudWxsLCJnaWxkZWQiOjAsImNsaWNrZWQiOmZhbHNlLCJ0aXRsZSI6Ik92ZXJ3YXRjaCAyIGlzIHRoZSB3b3JzdCBnYW1lIG9uIFN0ZWFtLCBhY2NvcmRpbmcgdG8gdXNlciByZXZpZXdzIHwgXCJUaGUgcGVvcGxlIHdobyBtYWtlIE92ZXJ3YXRjaCBwb3JuIHdvcmsgaGFyZGVyIHRoYW4gdGhlIHBlb3BsZSB3aG8gbWFrZSBPdmVyd2F0Y2hcIiIsImxpbmtfZmxhaXJfcmljaHRleHQiOltdLCJzdWJyZWRkaXRfbmFtZV9wcmVmaXhlZCI6InIvdGVjaG5vbG9neSIsImhpZGRlbiI6ZmFsc2UsInB3bHMiOjYsImxpbmtfZmxhaXJfY3NzX2NsYXNzIjoiZ2VuZXJhbCIsImRvd25zIjowLCJ0aHVtYm5haWxfaGVpZ2h0Ijo3OCwidG9wX2F3YXJkZWRfdHlwZSI6bnVsbCwiaGlkZV9zY29yZSI6dHJ1ZSwibmFtZSI6InQzXzE1cXE3NHoiLCJxdWFyYW50aW5lIjpmYWxzZSwibGlua19mbGFpcl90ZXh0X2NvbG9yIjoiZGFyayIsInVwdm90ZV9yYXRpbyI6MC44NSwiYXV0aG9yX2ZsYWlyX2JhY2tncm91bmRfY29sb3IiOm51bGwsInVwcyI6MTQsInRvdGFsX2F3YXJkc19yZWNlaXZlZCI6MCwibWVkaWFfZW1iZWQiOnt9LCJ0aHVtYm5haWxfd2lkdGgiOjE0MCwiYXV0aG9yX2ZsYWlyX3RlbXBsYXRlX2lkIjpudWxsLCJpc19vcmlnaW5hbF9jb250ZW50IjpmYWxzZSwidXNlcl9yZXBvcnRzIjpbXSwic2VjdXJlX21lZGlhIjpudWxsLCJpc19yZWRkaXRfbWVkaWFfZG9tYWluIjpmYWxzZSwiaXNfbWV0YSI6ZmFsc2UsImNhdGVnb3J5IjpudWxsLCJzZWN1cmVfbWVkaWFfZW1iZWQiOnt9LCJsaW5rX2ZsYWlyX3RleHQiOiJTb2Z0d2FyZSIsImNhbl9tb2RfcG9zdCI6ZmFsc2UsInNjb3JlIjoxNCwiYXBwcm92ZWRfYnkiOm51bGwsImlzX2NyZWF0ZWRfZnJvbV9hZHNfdWkiOmZhbHNlLCJhdXRob3JfcHJlbWl1bSI6dHJ1ZSwidGh1bWJuYWlsIjoiaHR0cHM6Ly9iLnRodW1icy5yZWRkaXRtZWRpYS5jb20vSkNRd1VjUTVFeGhWN0t1UFB5VUg4TjI5N2VZNk45M2ZuUHFpbHh4a2VsRS5qcGciLCJlZGl0ZWQiOmZhbHNlLCJhdXRob3JfZmxhaXJfY3NzX2NsYXNzIjpudWxsLCJhdXRob3JfZmxhaXJfcmljaHRleHQiOltdLCJnaWxkaW5ncyI6e30sInBvc3RfaGludCI6ImxpbmsiLCJjb250ZW50X2NhdGVnb3JpZXMiOm51bGwsImlzX3NlbGYiOmZhbHNlLCJzdWJyZWRkaXRfdHlwZSI6InB1YmxpYyIsImNyZWF0ZWQiOjE2OTIwMDY3MDcuMCwibGlua19mbGFpcl90eXBlIjoidGV4dCIsIndscyI6NiwicmVtb3ZlZF9ieV9jYXRlZ29yeSI6bnVsbCwiYmFubmVkX2J5IjpudWxsLCJhdXRob3JfZmxhaXJfdHlwZSI6InRleHQiLCJkb21haW4iOiJ0ZWNoc3BvdC5jb20iLCJhbGxvd19saXZlX2NvbW1lbnRzIjpmYWxzZSwic2VsZnRleHRfaHRtbCI6bnVsbCwibGlrZXMiOm51bGwsInN1Z2dlc3RlZF9zb3J0IjpudWxsLCJiYW5uZWRfYXRfdXRjIjpudWxsLCJ1cmxfb3ZlcnJpZGRlbl9ieV9kZXN0IjoiaHR0cHM6Ly93d3cudGVjaHNwb3QuY29tL25ld3MvOTk3NjYtb3ZlcndhdGNoLTItd29yc3QtZ2FtZS1zdGVhbS1hY2NvcmRpbmctdXNlci1yZXZpZXdzLmh0bWwiLCJ2aWV3X2NvdW50IjpudWxsLCJhcmNoaXZlZCI6ZmFsc2UsIm5vX2ZvbGxvdyI6ZmFsc2UsImlzX2Nyb3NzcG9zdGFibGUiOmZhbHNlLCJwaW5uZWQiOmZhbHNlLCJvdmVyXzE4IjpmYWxzZSwicHJldmlldyI6eyJpbWFnZXMiOlt7InNvdXJjZSI6eyJ1cmwiOiJodHRwczovL2V4dGVybmFsLXByZXZpZXcucmVkZC5pdC9qZk95alFBcWJXT1BFalFfdG9ZV3o4NWtfQTNpSkE0VkVYQlE4VkZLZXNVLmpwZz9hdXRvPXdlYnAmYW1wO3M9NjExNTU2NTBiM2QxN2E3YTcwZmFhOTJjYWIwNDQ4ZjU4YTlkMjA4YSIsIndpZHRoIjoxOTIwLCJoZWlnaHQiOjEwODB9LCJyZXNvbHV0aW9ucyI6W3sidXJsIjoiaHR0cHM6Ly9leHRlcm5hbC1wcmV2aWV3LnJlZGQuaXQvamZPeWpRQXFiV09QRWpRX3RvWVd6ODVrX0EzaUpBNFZFWEJROFZGS2VzVS5qcGc/d2lkdGg9MTA4JmFtcDtjcm9wPXNtYXJ0JmFtcDthdXRvPXdlYnAmYW1wO3M9NWEwNGE1N2VkYTU4Yzc4ZjEwNzdiZjU2YzcyMjUwYmRlOTk4NmRiOSIsIndpZHRoIjoxMDgsImhlaWdodCI6NjB9LHsidXJsIjoiaHR0cHM6Ly9leHRlcm5hbC1wcmV2aWV3LnJlZGQuaXQvamZPeWpRQXFiV09QRWpRX3RvWVd6ODVrX0EzaUpBNFZFWEJROFZGS2VzVS5qcGc/d2lkdGg9MjE2JmFtcDtjcm9wPXNtYXJ0JmFtcDthdXRvPXdlYnAmYW1wO3M9YTM0NGJkYTQ3OGVmM2Q4Y2M2MzgxZGJhODEyZmM5ZDE2YmMwZGMyZSIsIndpZHRoIjoyMTYsImhlaWdodCI6MTIxfSx7InVybCI6Imh0dHBzOi8vZXh0ZXJuYWwtcHJldmlldy5yZWRkLml0L2pmT3lqUUFxYldPUEVqUV90b1lXejg1a19BM2lKQTRWRVhCUThWRktlc1UuanBnP3dpZHRoPTMyMCZhbXA7Y3JvcD1zbWFydCZhbXA7YXV0bz13ZWJwJmFtcDtzPTQ5NTNmZmUyYzExOGEzNTAyYzU0MzllOWJiYjM2OGE4YjRmMmRhZDciLCJ3aWR0aCI6MzIwLCJoZWlnaHQiOjE4MH0seyJ1cmwiOiJodHRwczovL2V4dGVybmFsLXByZXZpZXcucmVkZC5pdC9qZk95alFBcWJXT1BFalFfdG9ZV3o4NWtfQTNpSkE0VkVYQlE4VkZLZXNVLmpwZz93aWR0aD02NDAmYW1wO2Nyb3A9c21hcnQmYW1wO2F1dG89d2VicCZhbXA7cz0yNmQwNjc0NjQ4NjJjMzRmYTM2MTc4NjY4NDNhYTEwNTE1MWQ1ZDhjIiwid2lkdGgiOjY0MCwiaGVpZ2h0IjozNjB9LHsidXJsIjoiaHR0cHM6Ly9leHRlcm5hbC1wcmV2aWV3LnJlZGQuaXQvamZPeWpRQXFiV09QRWpRX3RvWVd6ODVrX0EzaUpBNFZFWEJROFZGS2VzVS5qcGc/d2lkdGg9OTYwJmFtcDtjcm9wPXNtYXJ0JmFtcDthdXRvPXdlYnAmYW1wO3M9NWRjMTNkNjQ3M2VmNjRmYTc2Mzk1YTRlYjU4OTA4MjgxN2UyYThhZiIsIndpZHRoIjo5NjAsImhlaWdodCI6NTQwfSx7InVybCI6Imh0dHBzOi8vZXh0ZXJuYWwtcHJldmlldy5yZWRkLml0L2pmT3lqUUFxYldPUEVqUV90b1lXejg1a19BM2lKQTRWRVhCUThWRktlc1UuanBnP3dpZHRoPTEwODAmYW1wO2Nyb3A9c21hcnQmYW1wO2F1dG89d2VicCZhbXA7cz0yZWJmY2UxOGFhNTQzODY0ZTk2MDA5MjAzMzRkZmUyMjZjYjkxZWNjIiwid2lkdGgiOjEwODAsImhlaWdodCI6NjA3fV0sInZhcmlhbnRzIjp7fSwiaWQiOiJrbFRHVVQxdDJUSjlnWWF6NEVBNUUzM2lvVU9kazFlSHYyTE45RjctWERvIn1dLCJlbmFibGVkIjpmYWxzZX0sImFsbF9hd2FyZGluZ3MiOltdLCJhd2FyZGVycyI6W10sIm1lZGlhX29ubHkiOmZhbHNlLCJsaW5rX2ZsYWlyX3RlbXBsYXRlX2lkIjoiODVjNGQ3M2UtYTgxNi0xMWU5LTk1ZDUtMGVlNmI5NjQ5MWNjIiwiY2FuX2dpbGQiOmZhbHNlLCJzcG9pbGVyIjpmYWxzZSwibG9ja2VkIjpmYWxzZSwiYXV0aG9yX2ZsYWlyX3RleHQiOm51bGwsInRyZWF0bWVudF90YWdzIjpbXSwidmlzaXRlZCI6ZmFsc2UsInJlbW92ZWRfYnkiOm51bGwsIm1vZF9ub3RlIjpudWxsLCJkaXN0aW5ndWlzaGVkIjpudWxsLCJzdWJyZWRkaXRfaWQiOiJ0NV8ycWgxNiIsImF1dGhvcl9pc19ibG9ja2VkIjpmYWxzZSwibW9kX3JlYXNvbl9ieSI6bnVsbCwibnVtX3JlcG9ydHMiOm51bGwsInJlbW92YWxfcmVhc29uIjpudWxsLCJsaW5rX2ZsYWlyX2JhY2tncm91bmRfY29sb3IiOiIiLCJpZCI6IjE1cXE3NHoiLCJpc19yb2JvdF9pbmRleGFibGUiOnRydWUsInJlcG9ydF9yZWFzb25zIjpudWxsLCJhdXRob3IiOiJjaHJpc2RoNzkiLCJkaXNjdXNzaW9uX3R5cGUiOm51bGwsIm51bV9jb21tZW50cyI6Mywic2VuZF9yZXBsaWVzIjpmYWxzZSwid2hpdGVsaXN0X3N0YXR1cyI6ImFsbF9hZHMiLCJjb250ZXN0X21vZGUiOmZhbHNlLCJtb2RfcmVwb3J0cyI6W10sImF1dGhvcl9wYXRyZW9uX2ZsYWlyIjpmYWxzZSwiYXV0aG9yX2ZsYWlyX3RleHRfY29sb3IiOm51bGwsInBlcm1hbGluayI6Ii9yL3RlY2hub2xvZ3kvY29tbWVudHMvMTVxcTc0ei9vdmVyd2F0Y2hfMl9pc190aGVfd29yc3RfZ2FtZV9vbl9zdGVhbV9hY2NvcmRpbmcvIiwicGFyZW50X3doaXRlbGlzdF9zdGF0dXMiOiJhbGxfYWRzIiwic3RpY2tpZWQiOmZhbHNlLCJ1cmwiOiJodHRwczovL3d3dy50ZWNoc3BvdC5jb20vbmV3cy85OTc2Ni1vdmVyd2F0Y2gtMi13b3JzdC1nYW1lLXN0ZWFtLWFjY29yZGluZy11c2VyLXJldmlld3MuaHRtbCIsInN1YnJlZGRpdF9zdWJzY3JpYmVycyI6MTQ2MzQwOTQsImNyZWF0ZWRfdXRjIjoxNjkyMDA2NzA3LjAsIm51bV9jcm9zc3Bvc3RzIjowLCJtZWRpYSI6bnVsbCwiaXNfdmlkZW8iOmZhbHNlfX1dLCJiZWZvcmUiOm51bGx9fQ==';
          final realData = utf8.decode(base64.decode(realDataBase64));
          return Response(realData, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        final dataResponse = await redditApiProvider.getPost();
        expect(dataResponse.isRight, true);
        expect(dataResponse.right.kind, kind);
        final dataList = dataResponse.right.data;
        expect(dataList.after, after);
        expect(dataList.before, before);
        expect(dataList.dataList.length, length);
        final data = dataList.dataList[0];
        expect(data.id, id);
        expect(data.title, title);
        expect(data.authorFullName, author);
        expect(data.thumbnail, Uri.parse(thumbnail));
        expect(data.thumbnailHeight, thumbnailHeight);
        expect(data.thumbnailWidth, thumbnailWeight);
        expect(data.permalink, Uri.parse('$rootUrl$permalink'));
        expect(
            data.createdDateTime,
            DateTime.fromMillisecondsSinceEpoch((date * 1000).round(),
                isUtc: true));
      });

      test('first object with error type', () async {
        const kind = 'listing';
        const after = 'qwer';
        const before = 'asdf';
        const length = 2;
        const rootUrl = 'https://www.reddit.com';
        const id = '12345';
        const author = '23456';
        const title = '34567 title';
        const thumbnailHeight = 12;
        const thumbnailWeight = 34;
        const thumbnail = 'https://123.com/456.jpg';
        const permalink = '/567/890/';
        const date = 1691741421.0;
        final client = MockClient((request) async {
          const sampleDataString = '{"kind": "$kind", "data": '
              '{"after": "$after",'
              '"before": "$before",'
              '"dist": $length,'
              '"children": [{"data":{'
              '"author_fullname":"$author",'
              '"title":"$title",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":$id,'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}, {"data":{'
              '"author_fullname":"$author 2",'
              '"title":"$title 2",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}]}}';
          return Response(sampleDataString, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        final dataResponse = await redditApiProvider.getPost();
        expect(dataResponse.isRight, true);
        expect(dataResponse.right.kind, kind);
        final dataList = dataResponse.right.data;
        expect(dataList.after, after);
        expect(dataList.before, before);
        expect(dataList.dataList.length, length - 1);
        final data = dataList.dataList[0];
        expect(data.id, id);
        expect(data.title, '$title 2');
        expect(data.authorFullName, '$author 2');
        expect(data.thumbnail, Uri.parse(thumbnail));
        expect(data.thumbnailHeight, thumbnailHeight);
        expect(data.thumbnailWidth, thumbnailWeight);
        expect(data.permalink, Uri.parse('$rootUrl$permalink'));
        expect(
            data.createdDateTime,
            DateTime.fromMillisecondsSinceEpoch((date * 1000).round(),
                isUtc: true));
      });

      test('error type', () async {
        const kind = 'listing';
        const after = '1234';
        const before = 'asdf';
        const length = 2;
        const id = '12345';
        const author = '23456';
        const title = '34567 title';
        const thumbnailHeight = 12;
        const thumbnailWeight = 34;
        const thumbnail = 'https://123.com/456.jpg';
        const permalink = '/567/890/';
        const date = 1691741421.0;
        final client = MockClient((request) async {
          const sampleDataString = '{"kind": "$kind", "data": '
              '{"after": $after,'
              '"before": "$before",'
              '"dist": $length,'
              '"children": [{"data":{'
              '"author_fullname":"$author",'
              '"title":"$title",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":$id,'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}, {"data":{'
              '"author_fullname":"$author 2",'
              '"title":"$title 2",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}]}}';
          return Response(sampleDataString, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        final dataResponse = await redditApiProvider.getPost();
        expect(dataResponse.isLeft, true);
        expect(dataResponse.left, isA<FormatException>());
      });

      test('empty body', () async {
        final client = MockClient((request) async {
          const sampleDataString = '';
          return Response(sampleDataString, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        final result = await redditApiProvider.getPost();
        expect(result.isLeft, true);
        expect(result.left, isA<FormatException>());
      });

      test('empty json body', () async {
        final client = MockClient((request) async {
          const sampleDataString = '{}';
          return Response(sampleDataString, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        final result = await redditApiProvider.getPost();
        expect(result.isLeft, true);
        expect(result.left, isA<FormatException>());
      });
    });

    group('40x', () {
      test('400', () async {
        const sampleDataString = 'BAD_REQUEST';
        final client = MockClient((request) async {
          return Response(sampleDataString, StatusCode.BAD_REQUEST);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.BAD_REQUEST,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });

      test('401', () async {
        const sampleDataString = 'UNAUTHORIZED';
        final client = MockClient((request) async {
          return Response(sampleDataString, StatusCode.UNAUTHORIZED);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.UNAUTHORIZED,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });

      test('403', () async {
        const sampleDataString = 'FORBIDDEN';
        final client = MockClient((request) async {
          const sampleDataString = 'FORBIDDEN';
          return Response(sampleDataString, StatusCode.FORBIDDEN);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.FORBIDDEN,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });

      test('404', () async {
        const sampleDataString = 'NOT_FOUND';
        final client = MockClient((request) async {
          return Response(sampleDataString, StatusCode.NOT_FOUND);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.NOT_FOUND,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });

      test('405', () async {
        const sampleDataString = 'METHOD_NOT_ALLOWED';
        final client = MockClient((request) async {
          return Response(sampleDataString, StatusCode.METHOD_NOT_ALLOWED);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.METHOD_NOT_ALLOWED,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });
    });

    group('50x', () {
      test('500', () async {
        const sampleDataString = 'INTERNAL_SERVER_ERROR';
        final client = MockClient((request) async {
          return Response(sampleDataString, StatusCode.INTERNAL_SERVER_ERROR);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.INTERNAL_SERVER_ERROR,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });

      test('502', () async {
        const sampleDataString = 'BAD_GATEWAY';
        final client = MockClient((request) async {
          return Response(sampleDataString, StatusCode.BAD_GATEWAY);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.BAD_GATEWAY,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });

      test('503', () async {
        const sampleDataString = 'SERVICE_UNAVAILABLE';
        final client = MockClient((request) async {
          return Response(sampleDataString, StatusCode.SERVICE_UNAVAILABLE);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.SERVICE_UNAVAILABLE,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });

      test('505', () async {
        const sampleDataString = 'GATEWAY_TIMEOUT';
        final client = MockClient((request) async {
          return Response(sampleDataString, StatusCode.GATEWAY_TIMEOUT);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          await redditApiProvider.getPost();
        } on RedditApiProviderNetworkException catch (e) {
          const expected = RedditApiProviderNetworkException(
              StatusCode.GATEWAY_TIMEOUT,
              reason: sampleDataString);
          expect(e.statusCode, expected.statusCode);
          expect(e.reason, expected.reason);
        }
      });
    });

    group('parameter', () {
      test('positive limit', () async {
        const kind = 'listing';
        const after = 'qwer';
        const before = 'asdf';
        const length = 2;
        const rootUrl = 'https://www.reddit.com';
        const id = '12345';
        const author = '23456';
        const title = '34567 title';
        const thumbnailHeight = 12;
        const thumbnailWeight = 34;
        const thumbnail = 'https://123.com/456.jpg';
        const permalink = '/567/890/';
        const date = 1691741421.0;
        final client = MockClient((request) async {
          const sampleDataString = '{"kind": "$kind", "data": '
              '{"after": "$after",'
              '"before": "$before",'
              '"dist": $length,'
              '"children": [{"data":{'
              '"author_fullname":"$author",'
              '"title":"$title",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}, {"data":{'
              '"author_fullname":"$author 2",'
              '"title":"$title 2",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}]}}';
          return Response(sampleDataString, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        final dataResponse = await redditApiProvider.getPost(limit: 1);
        expect(dataResponse.isRight, true);
        expect(dataResponse.right.kind, kind);
        final dataList = dataResponse.right.data;
        expect(dataList.after, after);
        expect(dataList.before, before);
        expect(dataList.dataList.length, length);
        final data = dataList.dataList[0];
        expect(data.id, id);
        expect(data.title, title);
        expect(data.authorFullName, author);
        expect(data.thumbnail, Uri.parse(thumbnail));
        expect(data.thumbnailHeight, thumbnailHeight);
        expect(data.thumbnailWidth, thumbnailWeight);
        expect(data.permalink, Uri.parse('$rootUrl$permalink'));
        expect(
            data.createdDateTime,
            DateTime.fromMillisecondsSinceEpoch((date * 1000).round(),
                isUtc: true));
      });

      test('negative limit', () async {
        const kind = 'listing';
        const after = 'qwer';
        const before = 'asdf';
        const length = 2;
        const id = '12345';
        const author = '23456';
        const title = '34567 title';
        const thumbnailHeight = 12;
        const thumbnailWeight = 34;
        const thumbnail = 'https://123.com/456.jpg';
        const permalink = '/567/890/';
        const date = 1691741421.0;
        final client = MockClient((request) async {
          const sampleDataString = '{"kind": "$kind", "data": '
              '{"after": "$after",'
              '"before": "$before",'
              '"dist": $length,'
              '"children": [{"data":{'
              '"author_fullname":"$author",'
              '"title":"$title",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}, {"data":{'
              '"author_fullname":"$author 2",'
              '"title":"$title 2",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}]}}';
          return Response(sampleDataString, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          final _ = await redditApiProvider.getPost(limit: -1);
        } on RedditApiProviderInvalidParameterException catch (e) {
          const expected =
              RedditApiProviderInvalidParameterException('limit must > 0');
          expect(e.reason, expected.reason);
        }
      });

      test('zero limit', () async {
        const kind = 'listing';
        const after = 'qwer';
        const before = 'asdf';
        const length = 2;
        const id = '12345';
        const author = '23456';
        const title = '34567 title';
        const thumbnailHeight = 12;
        const thumbnailWeight = 34;
        const thumbnail = 'https://123.com/456.jpg';
        const permalink = '/567/890/';
        const date = 1691741421.0;
        final client = MockClient((request) async {
          const sampleDataString = '{"kind": "$kind", "data": '
              '{"after": "$after",'
              '"before": "$before",'
              '"dist": $length,'
              '"children": [{"data":{'
              '"author_fullname":"$author",'
              '"title":"$title",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}, {"data":{'
              '"author_fullname":"$author 2",'
              '"title":"$title 2",'
              '"thumbnail_height":$thumbnailHeight,'
              '"thumbnail_width":$thumbnailWeight,'
              '"thumbnail":"$thumbnail",'
              '"id":"$id",'
              '"permalink":"$permalink",'
              '"created_utc":$date'
              '}}]}}';
          return Response(sampleDataString, StatusCode.OK);
        });
        final redditApiProvider = RedditApiProvider(httpClient: client);
        try {
          final _ = await redditApiProvider.getPost(limit: 0);
        } on RedditApiProviderInvalidParameterException catch (e) {
          const expected =
              RedditApiProviderInvalidParameterException('limit must > 0');
          expect(e.reason, expected.reason);
        }
      });
    });
  });
}

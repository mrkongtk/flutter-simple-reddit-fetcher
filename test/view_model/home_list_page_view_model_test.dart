import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:simple_reddit_fetcher/repository/reddit_api_provider.dart';
import 'package:simple_reddit_fetcher/view_model/home_list_page_view_model.dart';

void main() {
  group('HomeListPageViewModel', () {
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

    HomeListPageViewModel? viewModel;

    setUp(() {
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
            '}}]}}';
        await Future.delayed(const Duration(milliseconds: 1000));
        return Response(sampleDataString, 200);
      });

      viewModel = HomeListPageViewModel(
          redditApiProvider: RedditApiProvider(httpClient: client));
    });

    tearDown(() {
      viewModel?.dispose();
    });

    test('initial state loading is false, after is null, dataList is empty',
        () async {
      final viewModelLocal = viewModel ?? fail('viewModel is not init yet');
      final state = await viewModelLocal.state.first;
      expect(state.isLoading, false);
      expect(state.after, null);
      expect(state.dataList.isEmpty, true);
    });

    test('retrieve', () {
      fakeAsync((async) async {
        final viewModelLocal = viewModel ?? fail('viewModel is not init yet');
        viewModelLocal.retrieve();

        final state = await viewModelLocal.state.first;
        expect(state.isLoading, true);
        expect(state.after, null);
        expect(state.dataList.isEmpty, true);

        async.elapse(const Duration(milliseconds: 1001));

        final stateAfter = await viewModelLocal.state.first;
        expect(stateAfter.isLoading, false);
        expect(stateAfter.after, after);
        expect(stateAfter.dataList.length, 1);

        final post = stateAfter.dataList[0];
        expect(post.id, id);
        expect(post.title, title);
        expect(post.authorFullName, author);
        expect(post.thumbnail, Uri.parse(thumbnail));
        expect(post.thumbnailHeight, thumbnailHeight);
        expect(post.thumbnailWidth, thumbnailWeight);
        expect(post.permalink, Uri.parse('$rootUrl$permalink'));
        expect(
            post.createdDateTime,
            DateTime.fromMillisecondsSinceEpoch((date * 1000).round(),
                isUtc: true));
      });
    });

    test('retrieve timeout', () {
      fakeAsync((async) async {
        final viewModelLocal = viewModel ?? fail('viewModel is not init yet');
        viewModelLocal.retrieve();

        final state = await viewModelLocal.state.first;
        expect(state.isLoading, true);
        expect(state.after, null);
        expect(state.dataList.isEmpty, true);

        async.elapse(const Duration(seconds: 11));

        final stateAfter = await viewModelLocal.state.first;
        expect(stateAfter.isLoading, false);
        expect(stateAfter.after, null);
        expect(stateAfter.dataList.isEmpty, true);
      });
    });
  });
}

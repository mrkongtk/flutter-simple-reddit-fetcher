import 'package:flutter_test/flutter_test.dart';
import 'package:simple_reddit_fetcher/model/reddit_post.dart';
import 'package:simple_reddit_fetcher/view_model/home_list_page_view_model.dart';

void main() {
  group('HomeListPageViewModel', () {
    late HomeListPageViewModel viewModel;

    setUp(() {
      viewModel = HomeListPageViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state loading is false, after is null, dataList is empty',
        () async {
      final state = await viewModel.state.first;

      expect(state.isLoading, false);
      expect(state.after, null);
      expect(state.dataList.isEmpty, true);
    });

    test('setLoading affecting the loading in state only', () async {
      viewModel.setLoading(true);

      final state = await viewModel.state.first;

      expect(state.isLoading, true);
      expect(state.after, null);
      expect(state.dataList.isEmpty, true);
    });

    test('append PostListData affecting after and dataList, but not loading',
        () async {
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
      final data = PostListResponse.fromJson(sampleDataString, rootUrl).data;

      viewModel.append(data);

      final state = await viewModel.state.first;

      expect(state.isLoading, false);
      expect(state.after, after);
      expect(state.dataList.length, 1);

      final post = state.dataList[0];
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
}

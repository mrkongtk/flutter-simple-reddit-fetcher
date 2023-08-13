import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_reddit_fetcher/model/reddit_post.dart';

void main() {
  group('PostData', () {
    test('correct data', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      final data = PostData.fromJson(sampleData, rootUrl);
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

    test('not url format root url', () {
      const rootUrl = '2iap';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      final data = PostData.fromJson(sampleData, rootUrl);
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

    test('missing id', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          // '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      expect(() => PostData.fromJson(sampleData, rootUrl),
          throwsA(isA<TypeError>()));
    });

    test('missing author', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          // '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      expect(() => PostData.fromJson(sampleData, rootUrl),
          throwsA(isA<TypeError>()));
    });

    test('missing title', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          // '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      expect(() => PostData.fromJson(sampleData, rootUrl),
          throwsA(isA<TypeError>()));
    });

    test('missing thumbnail', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          // '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      final data = PostData.fromJson(sampleData, rootUrl);
      expect(data.id, id);
      expect(data.title, title);
      expect(data.authorFullName, author);
      expect(data.thumbnail, null);
      expect(data.thumbnailHeight, thumbnailHeight);
      expect(data.thumbnailWidth, thumbnailWeight);
      expect(data.permalink, Uri.parse('$rootUrl$permalink'));
      expect(
          data.createdDateTime,
          DateTime.fromMillisecondsSinceEpoch((date * 1000).round(),
              isUtc: true));
    });

    test('missing thumbnail width', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          // '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      final data = PostData.fromJson(sampleData, rootUrl);
      expect(data.id, id);
      expect(data.title, title);
      expect(data.authorFullName, author);
      expect(data.thumbnail, Uri.parse(thumbnail));
      expect(data.thumbnailHeight, thumbnailHeight);
      expect(data.thumbnailWidth, 0);
      expect(data.permalink, Uri.parse('$rootUrl$permalink'));
      expect(
          data.createdDateTime,
          DateTime.fromMillisecondsSinceEpoch((date * 1000).round(),
              isUtc: true));
    });

    test('missing thumbnail height', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          // '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      final data = PostData.fromJson(sampleData, rootUrl);
      expect(data.id, id);
      expect(data.title, title);
      expect(data.authorFullName, author);
      expect(data.thumbnail, Uri.parse(thumbnail));
      expect(data.thumbnailHeight, 0);
      expect(data.thumbnailWidth, thumbnailWeight);
      expect(data.permalink, Uri.parse('$rootUrl$permalink'));
      expect(
          data.createdDateTime,
          DateTime.fromMillisecondsSinceEpoch((date * 1000).round(),
              isUtc: true));
    });

    test('missing permalink', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          // '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      expect(() => PostData.fromJson(sampleData, rootUrl),
          throwsA(isA<TypeError>()));
    });

    test('missing create date time', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink"'
          // '"created_utc":$date'
          '}}';
      final sampleData = jsonDecode(sampleDataString);
      expect(() => PostData.fromJson(sampleData, rootUrl),
          throwsA(isA<TypeError>()));
    });

    test('real data', () {
      const rootUrl = 'https://www.reddit.com';
      const id = '15nh37r';
      const author = 't2_f91xt';
      const title =
          'My friend made a “dark web gift shop” only visitable on the dark web which is as hilarious and absurd as it sounds';
      const thumbnailHeight = 79;
      const thumbnailWeight = 140;
      const thumbnail =
          'https://b.thumbs.redditmedia.com/JJ3RieEM0Z2eI53lQ1eZN_vbrB0fB6Fbt4-NCjIBjCw.jpg';
      const permalink =
          '/r/technology/comments/15nh37r/my_friend_made_a_dark_web_gift_shop_only/';
      const date = 1691684814.0;
      const sampleDataString =
          '{"kind":"t3","data":{"approved_at_utc":null,"subreddit":"technology","selftext":"","author_fullname":"t2_f91xt","saved":false,"mod_reason_title":null,"gilded":0,"clicked":false,"title":"My friend made a “dark web gift shop” only visitable on the dark web which is as hilarious and absurd as it sounds","link_flair_richtext":[],"subreddit_name_prefixed":"r/technology","hidden":false,"pwls":6,"link_flair_css_class":"general","downs":0,"thumbnail_height":79,"top_awarded_type":null,"hide_score":true,"name":"t3_15nh37r","quarantine":false,"link_flair_text_color":"dark","upvote_ratio":1.0,"author_flair_background_color":null,"ups":3,"total_awards_received":0,"media_embed":{},"thumbnail_width":140,"author_flair_template_id":null,"is_original_content":false,"user_reports":[],"secure_media":null,"is_reddit_media_domain":false,"is_meta":false,"category":null,"secure_media_embed":{},"link_flair_text":"Society","can_mod_post":false,"score":3,"approved_by":null,"is_created_from_ads_ui":false,"author_premium":false,"thumbnail":"https://b.thumbs.redditmedia.com/JJ3RieEM0Z2eI53lQ1eZN_vbrB0fB6Fbt4-NCjIBjCw.jpg","edited":false,"author_flair_css_class":null,"author_flair_richtext":[],"gildings":{},"post_hint":"link","content_categories":null,"is_self":false,"subreddit_type":"public","created":1691684814.0,"link_flair_type":"text","wls":6,"removed_by_category":null,"banned_by":null,"author_flair_type":"text","domain":"techcrunch.com","allow_live_comments":false,"selftext_html":null,"likes":null,"suggested_sort":null,"banned_at_utc":null,"url_overridden_by_dest":"https://techcrunch.com/2023/07/28/the-dark-web-gift-shop/","view_count":null,"archived":false,"no_follow":true,"is_crosspostable":false,"pinned":false,"over_18":false,"preview":{"images":[{"source":{"url":"https://external-preview.redd.it/qbPc3610l2y3iF4AaazGJEAFDIXh0arf8okljTRpyiE.jpg?auto=webp&amp;s=2fa29c789b571b99edc70f651af151dd1d170d93","width":1200,"height":685},"resolutions":[{"url":"https://external-preview.redd.it/qbPc3610l2y3iF4AaazGJEAFDIXh0arf8okljTRpyiE.jpg?width=108&amp;crop=smart&amp;auto=webp&amp;s=5601acdc148e6b1be17f0c320d7f6c468ae2dae3","width":108,"height":61},{"url":"https://external-preview.redd.it/qbPc3610l2y3iF4AaazGJEAFDIXh0arf8okljTRpyiE.jpg?width=216&amp;crop=smart&amp;auto=webp&amp;s=2f615911c49cf6fdee9eb6a30da4a5b17561aa2b","width":216,"height":123},{"url":"https://external-preview.redd.it/qbPc3610l2y3iF4AaazGJEAFDIXh0arf8okljTRpyiE.jpg?width=320&amp;crop=smart&amp;auto=webp&amp;s=8333766fceed06cefbe6b986cbe3858635bcc037","width":320,"height":182},{"url":"https://external-preview.redd.it/qbPc3610l2y3iF4AaazGJEAFDIXh0arf8okljTRpyiE.jpg?width=640&amp;crop=smart&amp;auto=webp&amp;s=07422a3dd85b3a89abcd7cb127ffccd314bb584c","width":640,"height":365},{"url":"https://external-preview.redd.it/qbPc3610l2y3iF4AaazGJEAFDIXh0arf8okljTRpyiE.jpg?width=960&amp;crop=smart&amp;auto=webp&amp;s=241f36c3b35d967eb5542726522aaadee8646e9a","width":960,"height":548},{"url":"https://external-preview.redd.it/qbPc3610l2y3iF4AaazGJEAFDIXh0arf8okljTRpyiE.jpg?width=1080&amp;crop=smart&amp;auto=webp&amp;s=95e7466cdaffe65513bffcfa24df9d8e25fe3833","width":1080,"height":616}],"variants":{},"id":"-W4bNeb3FZ0fwEmdYLmkUvYIdpS0hc-A4MYVI0neFEU"}],"enabled":false},"all_awardings":[],"awarders":[],"media_only":false,"link_flair_template_id":"80187d9a-a816-11e9-a79b-0ea66e3761e6","can_gild":false,"spoiler":false,"locked":false,"author_flair_text":null,"treatment_tags":[],"visited":false,"removed_by":null,"mod_note":null,"distinguished":null,"subreddit_id":"t5_2qh16","author_is_blocked":false,"mod_reason_by":null,"num_reports":null,"removal_reason":null,"link_flair_background_color":"","id":"15nh37r","is_robot_indexable":true,"report_reasons":null,"author":"eligraham91","discussion_type":null,"num_comments":1,"send_replies":true,"whitelist_status":"all_ads","contest_mode":false,"mod_reports":[],"author_patreon_flair":false,"author_flair_text_color":null,"permalink":"/r/technology/comments/15nh37r/my_friend_made_a_dark_web_gift_shop_only/","parent_whitelist_status":"all_ads","stickied":false,"url":"https://techcrunch.com/2023/07/28/the-dark-web-gift-shop/","subreddit_subscribers":14611336,"created_utc":1691684814.0,"num_crossposts":0,"media":null,"is_video":false}}';
      final sampleData = jsonDecode(sampleDataString);
      final data = PostData.fromJson(sampleData, rootUrl);
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
  });

  group('PostListData', () {
    test('correct data', () {
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
      const sampleDataString = '{"after": "$after",'
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
          '}}]}';
      final sampleData = jsonDecode(sampleDataString);
      final dataList = PostListData.fromJson(sampleData, rootUrl);
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

    test('missing before', () {
      const after = 'qwer';
      const length = 1;
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"after": "$after",'
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
          '}}]}';
      final sampleData = jsonDecode(sampleDataString);
      final dataList = PostListData.fromJson(sampleData, rootUrl);
      expect(dataList.after, after);
      expect(dataList.before, null);
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

    test('missing after', () {
      const before = 'asdf';
      const length = 1;
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{'
          // '"after": "$after",'
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
          '}}]}';
      final sampleData = jsonDecode(sampleDataString);
      expect(() => PostListData.fromJson(sampleData, rootUrl),
          throwsA(isA<TypeError>()));
    });

    test('missing children', () {
      const after = 'qwer';
      const before = 'asdf';
      const length = 0;
      const rootUrl = 'https://www.reddit.com';
      const sampleDataString = '{"after": "$after",'
          '"before": "$before",'
          '"dist": $length}';
      final sampleData = jsonDecode(sampleDataString);
      final dataList = PostListData.fromJson(sampleData, rootUrl);
      expect(dataList.after, after);
      expect(dataList.before, before);
      expect(dataList.dataList.length, length);
    });

    test('with error Post Data', () {
      const after = 'qwer';
      const before = 'asdf';
      const length = 0;
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"after": "$after",'
          '"before": "$before",'
          '"dist": $length,'
          '"children": [{"data":{'
          '"author_fullname":"$author",'
          '"title":"$title",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink2":"$permalink",'
          '"created_utc":$date'
          '}}]}';
      final sampleData = jsonDecode(sampleDataString);
      final dataList = PostListData.fromJson(sampleData, rootUrl);
      expect(dataList.after, after);
      expect(dataList.before, before);
      expect(dataList.dataList.length, length);
    });

    test('with 1 error Post Data', () {
      const after = 'qwer';
      const before = 'asdf';
      const length = 1;
      const rootUrl = 'https://www.reddit.com';
      const id = '12345';
      const author = '23456';
      const title = '34567 title';
      const thumbnailHeight = 12;
      const thumbnailWeight = 34;
      const thumbnail = 'https://123.com/456.jpg';
      const permalink = '/567/890/';
      const date = 1691741421.0;
      const sampleDataString = '{"after": "$after",'
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
          '"title2":"$title 2",'
          '"thumbnail_height":$thumbnailHeight,'
          '"thumbnail_width":$thumbnailWeight,'
          '"thumbnail":"$thumbnail",'
          '"id":"$id",'
          '"permalink":"$permalink",'
          '"created_utc":$date'
          '}}]}';
      final sampleData = jsonDecode(sampleDataString);
      final dataList = PostListData.fromJson(sampleData, rootUrl);
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
  });

  group("PostListResponse", () {
    test('correct data', () {
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
      final dataResponse = PostListResponse.fromJson(sampleDataString, rootUrl);
      expect(dataResponse.kind, kind);
      final dataList = dataResponse.data;
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

    test('missing kind', () {
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
      const sampleDataString = '{'
          // '"kind": "$kind", '
          '"data": '
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
      expect(() => PostListResponse.fromJson(sampleDataString, rootUrl),
          throwsA(isA<TypeError>()));
    });

    test('missing kind', () {
      const kind = 'listing';
      const rootUrl = 'https://www.reddit.com';
      const sampleDataString = '{"kind": "$kind"}';
      expect(() => PostListResponse.fromJson(sampleDataString, rootUrl),
          throwsA(isA<TypeError>()));
    });

    test('incorrect json', () {
      const rootUrl = 'https://www.reddit.com';
      const sampleDataString = '';
      expect(() => PostListResponse.fromJson(sampleDataString, rootUrl),
          throwsA(isA<FormatException>()));
    });
  });
}

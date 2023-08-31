import 'dart:convert';
import 'dart:math';

class PostData {
  final String id;
  final String authorFullName;
  final String title;
  final Uri? thumbnail;
  final int thumbnailWidth;
  final int thumbnailHeight;
  final Uri permalink;
  final DateTime createdDateTime;

  PostData._(
      this.id,
      this.authorFullName,
      this.title,
      this.thumbnail,
      this.thumbnailWidth,
      this.thumbnailHeight,
      this.permalink,
      this.createdDateTime);

  factory PostData.fromJson(Map<String, dynamic> json, String rootUrl) {
    String id = json['data']['id'];
    String authorName = json['data']['author_fullname'];
    String title = json['data']['title'];
    String? thumbnail = json['data']['thumbnail'];
    int? thumbnailWidth = json['data']['thumbnail_width'];
    int? thumbnailHeight = json['data']['thumbnail_height'];
    String permalink = json['data']['permalink'];
    double createdDateTime = json['data']['created_utc'];
    return PostData._(
        id,
        authorName,
        title,
        thumbnail != null
            ? thumbnail.startsWith('http')
                ? Uri.parse(thumbnail)
                : Uri.parse('$rootUrl$thumbnail')
            : null,
        thumbnailWidth ?? 0,
        thumbnailHeight ?? 0,
        permalink.startsWith('http')
            ? Uri.parse(permalink)
            : Uri.parse('$rootUrl$permalink'),
        DateTime.fromMillisecondsSinceEpoch((createdDateTime * 1000).round(),
            isUtc: true));
  }
}

class PostListData {
  final String after;
  final String? before;
  final List<PostData> dataList;

  PostListData(this.after, this.before, this.dataList);

  static PostData? _postDataFromJson(
      Map<String, dynamic> json, String rootUrl) {
    try {
      return PostData.fromJson(json, rootUrl);
    } on TypeError {
      return null;
    }
  }

  factory PostListData.fromJson(Map<String, dynamic> json, String rootUrl) {
    final Iterable? children = json['children'];
    final postListData = children != null
        ? children
            .map((c) => _postDataFromJson(c, rootUrl))
            .whereType<PostData>()
            .toList(growable: false)
        : List<PostData>.empty(growable: false);
    return PostListData(json['after'], json['before'], postListData);
  }
}

class PostListResponse {
  final String kind;
  final PostListData data;

  PostListResponse(this.kind, this.data);

  factory PostListResponse.fromJson(String jsonString, String rootUrl) {
    final json = jsonDecode(jsonString);
    return PostListResponse(
        json['kind'], PostListData.fromJson(json['data'], rootUrl));
  }
}

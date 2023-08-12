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

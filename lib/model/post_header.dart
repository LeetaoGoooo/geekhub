import 'Meta.dart';

/// @file   :   post.dart
/// @author :   leetao
/// @date   :   2/23/21 10:26 AM
/// @email  :   leetao94@gmail.com
/// @desc   :   帖子 body 详情


class PostHeader {
  String url;
  String avatar;
  String title;
  String author;
  String content;
  String publishTime;
  Meta meta;
  int commentPage;
  int currentPage;

  PostHeader.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    url = json['url'];
    avatar = json['avatar'];
    title = json['title'];
    author = json['author'];
    publishTime = json['publishTime'];
    meta = Meta.fromJson(json['meta']);
    content = json['content'];
    commentPage = json['commentPage'];
  }

  static List<PostHeader> listFromJson(List<dynamic> json) {
    return json == null
        ? List<PostHeader>()
        : json.map((value) => PostHeader.fromJson(value)).toList();
  }
}

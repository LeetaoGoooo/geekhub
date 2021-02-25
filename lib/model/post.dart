import 'package:geekhub/model/comment.dart';

import 'Meta.dart';

/// @file   :   post.dart
/// @author :   leetao
/// @date   :   2/23/21 10:26 AM
/// @email  :   leetao94@gmail.com
/// @desc   :   帖子详情


class Post {
  String url;
  String avatar;
  String title;
  String author;
  String content;
  String publishTime;
  Meta meta;
  List<Comment> comments;
  int commentPage;
  int currentPage;

  Post.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    url = json['url'];
    avatar = json['avatar'];
    title = json['title'];
    author = json['author'];
    publishTime = json['publishTime'];
    meta = Meta.fromJson(json['meta']);
    content = json['content'];
    comments = Comment.listFromJson(json['comments']);
    commentPage = json['commentPage'];
  }

  static List<Post> listFromJson(List<dynamic> json) {
    return json == null
        ? List<Post>()
        : json.map((value) => Post.fromJson(value)).toList();
  }
}

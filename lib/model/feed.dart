/// model/feed.dart
/// 主页信息流

import 'package:geekhub/model/meta.dart';

class Feed {
  String avatar;
  Meta meta;
  String title;
  String url;
  String commentsCount;
  String author;
  String profile;
  String lastReplyTime;
  String lastReplyUser;
  String subDescription; // 补充说明
  String subCatagory; // 补充类别

  Feed.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    avatar = json['avatar'];
    meta = Meta.fromJson(json['meta']);
    title = json['title'];
    url = json['url'];
    commentsCount = json['commentsCount'];
    author = json['author'];
    profile = json['profile'];
    lastReplyUser = json['lastReplyUser'];
    lastReplyTime = json['lastReplyTime'];
    subDescription = json['subDescription'];
    subCatagory = json['subCatagory'];
  }

  static List<Feed> listFromJson(List<dynamic> json) {
    return json == null
        ? List<Feed>()
        : json.map((value) => Feed.fromJson(value)).toList();
  }

  @override
  String toString() {
    return {
        "avatar":this.avatar,
        "meta": this.meta,
        "commentsCount": this.commentsCount,
        "title": this.title,
        "url": this.url,
        "author": this.author,
        "profile": this.profile,
        "lastReplyUser": this.lastReplyUser,
        "lastReplyTime": this.lastReplyTime,
        "subCatagory": this.subCatagory,
        "subDescription": this.subDescription
      }.toString();
  }
}

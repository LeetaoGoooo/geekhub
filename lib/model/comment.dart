import 'package:equatable/equatable.dart';

/// @file   :   comment
/// @author :   leetao
/// @date   :   2/23/21 10:35 AM
/// @email  :   leetao94@gmail.com
/// @desc   :   评论

// ignore: must_be_immutable
class Comment extends Equatable{
  String id;
  String avatar;
  String author;
  String profile;
  String replyTime;
  String order;
  int upCount;
  String content;

  Comment.fromJson(Map<String,dynamic> json) {
    if (json == null) return;
    id = json['id'];
    avatar = json['avatar'];
    author = json['author'];
    profile = json['profile'];
    replyTime = json['replyTime'];
    order = json['order'];
    upCount = json['upCount'];
    content = json['content'];
  }

  static List<Comment> listFromJson(List<dynamic> json) {
    return json == null
        ? List<Comment>()
        : json.map((value) => Comment.fromJson(value)).toSet().toList();
  }

  @override
  List<Object> get props => [id];

}
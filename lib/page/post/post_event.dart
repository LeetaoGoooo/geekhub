import 'package:geekhub/model/post.dart';

/// @file   :   post_event
/// @author :   leetao
/// @date   :   2/23/21 10:23 AM
/// @email  :   leetao94@gmail.com
/// @desc   :   帖子详情 event

abstract class PostEvent{

}


/// 获取帖子详情事件
class PostFetched extends PostEvent{
  final String url;
  final int page;

  PostFetched(this.url,{this.page});
}

class PostComment extends PostEvent {
  final Post post;
  PostComment(this.post);
}
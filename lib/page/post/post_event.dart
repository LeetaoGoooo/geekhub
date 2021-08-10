import 'package:geekhub/model/post_header.dart';

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
  PostFetched(this.url);
}

/// 帖子刷新事件
class PostRefresh extends PostEvent {
  final PostHeader topic;
  PostRefresh(this.topic);
}
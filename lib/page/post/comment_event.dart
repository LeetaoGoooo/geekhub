

import 'package:geekhub/model/comment_action.dart';

class CommentEvent {}

/// 获取事件
class CommentFetched extends CommentEvent {
  final String url;
  final int page;

  CommentFetched(this.url, this.page);
}

/// 刷新事件
class CommentLoadMore extends CommentEvent {
  CommentLoadMore();
}


class CommentPost extends CommentEvent {
  final CommentAction commentAction;
  CommentPost(this.commentAction);
}
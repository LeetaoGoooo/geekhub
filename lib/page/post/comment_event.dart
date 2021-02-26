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

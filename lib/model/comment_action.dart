class CommentAction {
  String targetType;
  String targetId;
  String counterBase ='0';
  String replyToId = '0';
  String ua = 'GeekHub App By Leetao';
  String content;

  CommentAction.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    targetType = json['targetType'];
    targetId = json['targetId'];
    counterBase = json['counterBase'];
    replyToId = json['replyToId'];
    ua = json['ua'];
    content = json['content'];
  }
}

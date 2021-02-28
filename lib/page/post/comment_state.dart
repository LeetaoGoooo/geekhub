import 'package:geekhub/model/post_body.dart';

abstract class CommentState {
  const CommentState();
}

class CommentInit extends CommentState {
  CommentInit();
}

class CommentLoading extends CommentState {
  final PostBody comment;

  CommentLoading({this.comment});
}

class CommentFailure extends CommentState {
  final PostBody comment;
  CommentFailure({this.comment});
}

class CommentSuccess extends CommentState {
  final PostBody comment;
  final int page;
  final String url;
  CommentSuccess({this.comment,this.page,this.url});
}


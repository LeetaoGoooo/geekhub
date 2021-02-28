import 'package:geekhub/model/post_header.dart';

/// @file   :   post_state
/// @author :   leetao
/// @date   :   2/23/21 3:42 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   Post 的状态

abstract class PostState {
  const PostState();
}

class PostInit extends PostState {}

class PostFailure extends PostState {}

class PostSuccess extends PostState {
  final PostHeader topic;

  PostSuccess(this.topic);
}

class PostRefreshFailure extends PostState {
  final PostHeader topic;
  PostRefreshFailure(this.topic);
}

class PostRefreshSuccess extends PostState {
  final PostHeader topic;
  PostRefreshSuccess(this.topic);
}

class MakeCommentSuccess extends PostState {
  final PostHeader topic;
  MakeCommentSuccess(this.topic);
}

class MakeCommentFailed extends PostState {
  final PostHeader topic;
  MakeCommentFailed(this.topic);
}

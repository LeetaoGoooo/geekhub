import 'package:geekhub/model/post.dart';

/// @file   :   post_state
/// @author :   leetao
/// @date   :   2/23/21 3:42 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   Post 的状态

abstract class PostState {
  const PostState();
}


class PostInit extends PostState{

}


class PostFailure extends PostState{

}

class PostSuccess extends PostState {
  final Post post;

  PostSuccess({this.post});
}


class PostCommentRefresh extends PostState {
  final Post post;
  PostCommentRefresh({this.post});
}

class PostCommentSuccess extends PostState {
  final Post post;
  PostCommentSuccess({this.post});
}

class PostCommentFailure extends PostState {

}
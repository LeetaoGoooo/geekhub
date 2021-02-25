/// @file   :   post_bloc
/// @author :   leetao
/// @date   :   2/23/21 3:45 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   Post bloc

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/api.dart';
import 'package:geekhub/model/post.dart';
import 'package:geekhub/page/post/post_event.dart';
import 'package:geekhub/page/post/post_state.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInit());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
    print("currentState:$state");
    if (event is PostFetched) {
      String url = event.url;
      try {
        if (currentState is PostInit) {
          var post = await Api.getPostByUrl('$url?page=1');
          post.currentPage = 1;
          yield PostSuccess(post: post);
          return;
        }
        if (currentState is PostSuccess) {
          final post = await Api.getPostByUrl(url);
          yield PostSuccess(post: post);
          return;
        }
      } catch (_) {
        yield PostFailure();
      }
    }
    if (event is PostComment) {
      Post currentPost = event.post;
      int page = currentPost.currentPage + 1;
      try {
        if (state is PostCommentRefresh) {
          var post = await Api.getPostByUrl('${currentPost.url}?page=$page');
          post.currentPage = page;
          post.comments += currentPost.comments;
        }
      } catch (_) {
        yield PostCommentFailure();
      }
    }
  }

  @override
  Stream<Transition<PostEvent, PostState>> transformEvents(
    Stream<PostEvent> events,
    TransitionFunction<PostEvent, PostState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}

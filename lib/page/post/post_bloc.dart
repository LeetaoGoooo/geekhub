/// @file   :   post_bloc
/// @author :   leetao
/// @date   :   2/23/21 3:45 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   Post bloc

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/api.dart';
import 'package:geekhub/api/comment_api.dart';
import 'package:geekhub/model/auth_model.dart';
import 'package:geekhub/model/comment_form.dart';
import 'package:geekhub/model/user.dart';
import 'package:geekhub/page/post/post_event.dart';
import 'package:geekhub/page/post/post_state.dart';
import 'package:geekhub/repository/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInit());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
    print('currentState is $state event is $event');
    if (event is PostFetched) {
      String url = event.url;
      try {
        if (currentState is PostInit) {
          var post = await Api.getPostByUrl(url);
          post.currentPage = 1;
          yield PostSuccess(post);
          return;
        }
      } catch (_) {
        yield PostFailure();
      }
    }
    if (event is PostRefresh) {
      String url = event.topic.url;
      try {
        // if (currentState is PostSuccess || currentState is PostRefreshSuccess || currentState is  PostRefreshFailure) {
        var post = await Api.getPostByUrl(url);
        yield PostRefreshSuccess(post);
        return;
        // }
      } catch (_) {
        yield PostRefreshFailure(event.topic);
      }
    }

    if (event is CommentPost) {
      var currentTopic = null;
      if (currentState is PostRefreshSuccess) {
        currentTopic = currentState.topic;
      }
      if (currentState is PostRefreshFailure) {
        currentTopic = currentState.topic;
      }
      if (currentState is PostSuccess) {
        currentTopic = currentState.topic;
      }
      if (currentTopic != null) {
        CommentForm commentForm =
            await CommentApi.getCommentForm('https://www.geekhub.com${currentTopic.url}');
        var commentSuccess =
            await CommentApi.makeComment(event.commentAction, commentForm);
        if (commentSuccess) {
          yield MakeCommentSuccess(currentTopic);
          return;
        }
        yield MakeCommentFailed(currentTopic);
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

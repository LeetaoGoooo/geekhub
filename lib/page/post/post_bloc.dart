/// @file   :   post_bloc
/// @author :   leetao
/// @date   :   2/23/21 3:45 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   Post bloc

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/api.dart';
import 'package:geekhub/page/post/post_event.dart';
import 'package:geekhub/page/post/post_state.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInit());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
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

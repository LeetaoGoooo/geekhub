import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/comment_api.dart';
import 'package:geekhub/api/feeds_api.dart';
import 'package:geekhub/model/comment_form.dart';
import 'package:geekhub/page/post/comment_event.dart';
import 'package:geekhub/page/post/comment_state.dart';
import 'package:rxdart/rxdart.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentInit());

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    var currentState = state;
    if (event is CommentFetched) {
      String url = event.url;
      int page = event.page;
      try {
        if (currentState is CommentInit || currentState is CommentSuccess) {
          yield CommentLoading();
          var postBody = await FeedsApi.getCommentsByUrl(url, page);
          yield CommentSuccess(comment: postBody, page: page, url: url);
          return;
        }
      } catch (_) {
        yield CommentFailure();
      }
    }
    if (event is CommentLoadMore) {
      try {
        if (currentState is CommentSuccess) {
          if (currentState.comment.totalPage >= currentState.page + 1) {
            yield CommentLoading(comment: currentState.comment);
            var postBody = await FeedsApi.getCommentsByUrl(
                currentState.url, currentState.page + 1);
            postBody.comments += currentState.comment.comments;
            yield CommentSuccess(
                comment: postBody,
                page: currentState.page + 1,
                url: currentState.url);
          } else {
            yield CommentSuccess(
                comment: currentState.comment,
                page: currentState.page,
                url: currentState.url);
          }
        }
      } catch (_) {
        yield CommentFailure();
      }
    }

    if (event is CommentPost) {
      if (currentState is CommentSuccess) {
        CommentForm commentForm = await CommentApi.getCommentForm(
            'https://www.geekhub.com${currentState.url}');
        var commentSuccess =
            await CommentApi.makeComment(event.commentAction, commentForm);
        if (commentSuccess) {
          var postBody = await FeedsApi.getCommentsByUrl(currentState.url, 1);
          yield CommentSuccess(
              comment: postBody, page: 1, url: currentState.url);
          return;
        } else {
          yield CommentSuccess(
              comment: currentState.comment,
              page: currentState.page,
              url: currentState.url);
        }
      }
    }
  }

  @override
  Stream<Transition<CommentEvent, CommentState>> transformEvents(
    Stream<CommentEvent> events,
    TransitionFunction<CommentEvent, CommentState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}

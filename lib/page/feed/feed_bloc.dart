import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/api.dart';
import 'package:geekhub/page/feed/feed_event.dart';
import 'package:geekhub/page/feed/feed_state.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInit());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    final currentState = state;
    print("currentState:$state");
    if (event is FeedFetched) {
      try {
        if (currentState is FeedInit) {
          String url = 'https://www.geekhub.com';
          if (event.key != 'all') {
            url = '$url/${event.key}';
          }
          final feeds = await Api.getFeedListByUrl(url);
          print("get feed:${feeds.length}");
          yield FeedSuccess(feeds: feeds);
          return;
        }
        if (currentState is FeedSuccess) {
          /// 比较 两次的 feeds 是否一样
          // yield HomeFeedSuccess(feeds: state.states);
          return;
        }
      } catch (e) {
        print(e);
        yield FeedFailure();
      }
    }
  }

  @override
  Stream<Transition<FeedEvent, FeedState>> transformEvents(
    Stream<FeedEvent> events,
    TransitionFunction<FeedEvent, FeedState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}

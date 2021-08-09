import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/feeds_api.dart';
import 'package:geekhub/page/feed/feed_event.dart';
import 'package:geekhub/page/feed/feed_state.dart';
import 'package:rxdart/rxdart.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInit());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    final currentState = state;
    print("currentState:$state");
    bool groupOrNot = false;
    if (event is FeedFetched) {
      try {
        if (currentState is FeedInit) {
          String url = 'https://www.geekhub.com';
          if (event.key != null) {
            if (event.key != 'all') {
              url = '$url/${event.key}';
            }
          } else {
            url = '$url${event.url}';
            groupOrNot = true;
          }

          final feeds = await FeedsApi.getFeedListByUrl(url,groupOrNot: groupOrNot);
          print("get feed:${feeds.length}");
          yield FeedSuccess(feeds: feeds);
          return;
        }
        if (currentState is FeedSuccess) {
          String url = 'https://www.geekhub.com';
          if (event.key != null) {
            if (event.key != 'all') {
              url = '$url/${event.key}';
            }
          } else {
            url = '$url${event.url}';
          }
          final feeds = await FeedsApi.getFeedListByUrl(url,groupOrNot: groupOrNot);
          print("get feed:${feeds.length}");
          yield FeedSuccess(feeds: feeds);
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

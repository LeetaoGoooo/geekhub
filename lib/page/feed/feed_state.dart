

import 'package:geekhub/model/feed.dart';

abstract class FeedState {
  const FeedState();
}

class FeedInit extends FeedState{

}

class FeedFailure extends FeedState {

}

class FeedSuccess extends FeedState {
  final List<Feed> feeds;

  const FeedSuccess({this.feeds});
}
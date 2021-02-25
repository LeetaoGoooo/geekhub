abstract class FeedEvent {

}

class FeedFetched extends FeedEvent {
  final String key;
  FeedFetched(this.key);
}
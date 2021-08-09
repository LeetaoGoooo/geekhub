abstract class FeedEvent {

}

class FeedFetched extends FeedEvent {
  final String key;
  final String url;
  FeedFetched({this.key,this.url});
}
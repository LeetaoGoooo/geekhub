import 'package:flutter_test/flutter_test.dart';
import 'package:geekhub/api/api.dart';

void main() {
  test('getHomeFeedList.', () async {
     var res =  await Api.getFeedListByUrl('https://www.geekhub.com');
     var feed = res[0];
     print({
        "avatar":feed.avatar,
        "meta": feed.meta,
        "commentsCount": feed.commentsCount,
        "title": feed.title,
        "url": feed.url,
        "author": feed.author,
        "profile": feed.profile,
        "lastReplyUser": feed.lastReplyUser,
        "lastReplyTime": feed.lastReplyTime,
        "subCatagory": feed.subCatagory,
        "subDescription": feed.subDescription
      });
     expect(res.length > 0, true);
  });
}
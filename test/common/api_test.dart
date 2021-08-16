import 'package:test/test.dart';
import 'package:geekhub/api/feeds_api.dart';
import 'package:geekhub/api/groups_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('getHomeFeedList.', () async {
     var res =  await FeedsApi.getFeedListByUrl('https://www.geekhub.com');
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

  test("getGroups", () async {
     SharedPreferences.setMockInitialValues({});
     var res = await GroupsApi.getGroupListByUrl('https://www.geekhub.com');
     var group = res[0];
     print(group.toString());
     expect(res.length > 0, true);
  });
}
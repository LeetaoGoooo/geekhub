import 'package:geekhub/model/feed.dart';
import 'package:geekhub/model/groups.dart';
import 'package:geekhub/repository/user_repository.dart';
import 'package:html/dom.dart';


class Utils {
    static Future<Map> getHeaders() async{
    var user = await new UserRepository().getUser();
    var headers = {"user-agent": "GeekHub App by Leetao"};
    if (user != null) {
      headers['cookie'] = user.sessionId;
    }
    return headers;
  }


    /// 摸鱼模式
    static List<Feed> getByFishMode(Document doc,{bool groupOrNot}) {
      List<Feed> feeds = [];
      Element feedDiv = doc.getElementById("home-feed-list");
      if (groupOrNot) {
        feedDiv = doc.querySelector("main > div");
      }
      List<Element> feedEleList = feedDiv.querySelectorAll("feed");

      for (var feedEle in feedEleList) {
        var avatar =
        feedEle.querySelector("div > div > div > img").attributes['src'];

        var metaEle = feedEle.querySelector("div > div > div >  div > a.sub");
        var meta = {
          "name": metaEle.text.trim(),
          "url": metaEle.attributes['href']
        };

        var authorEle = feedEle.querySelector("a.sub.font-medium");
        var author = authorEle.text;
        var profile = authorEle.attributes['href'];

        var lastReplyEle = feedEle.querySelector('div > div > div > a > span');
        var lastReplyUser = lastReplyEle.text;
        var lastReplyTime =
            feedEle.querySelectorAll("div > div > div > span")[1].text;

        var titleEle = feedEle.querySelector("a.text-base");
        var title = titleEle.text;
        var url = titleEle.attributes['href'];

        var commentsCount =
            feedEle.querySelectorAll("div > div > div > a > span")[2].text;

        var spanList = feedEle.querySelectorAll("div > div > div > div > a");
        var subDescription = "";
        var subCatagory = "";

        if (spanList.length == 2) {
          subCatagory = spanList[0].text;
        } else if (spanList.length == 3) {
          subDescription = spanList[0].text;
          subCatagory = spanList[1].text;
        }

        Feed homeFeed = Feed.fromJson({
          "avatar": avatar,
          "meta": meta,
          "commentsCount": commentsCount.trim(),
          "title": title.trim(),
          "url": url.trim(),
          "author": author.trim(),
          "profile": profile.trim(),
          "lastReplyUser": lastReplyUser.trim(),
          "lastReplyTime": lastReplyTime.trim(),
          "subCatagory": subCatagory.trim(),
          "subDescription": subDescription.trim()
        });
        feeds.add(homeFeed);
      }

      return feeds;
    }

    /// 信息流模式
    static List<Feed> getByInfoMode(Document doc, {bool groupOrNot = false}) {
      List<Feed> feeds = [];
      Element feedDiv = doc.getElementById("home-feed-list");
      if (groupOrNot) {
        feedDiv = doc.querySelector("main > div");
      }
      List<Element> articles = feedDiv.getElementsByTagName("article");

      for (var article in articles) {
        var avatar = article.querySelector("img").attributes['src'];
        var metaEle = article.querySelector("div > div > div > .meta");
        var meta = {
          "name": metaEle.text.trim(),
          "url": metaEle.attributes['href']
        };
        var commentsCount = article.querySelector(".comments-count").text;
        var spanList = article.querySelectorAll("div > div > div > span");
        var subDescription = "";
        var subCatagory = "";
        if (spanList.length == 2) {
          subCatagory = spanList[0].text;
        } else if (spanList.length == 3) {
          subDescription = spanList[0].text;
          subCatagory = spanList[1].text;
        }

        var titleEle = article.querySelector("div > h3 > a");
        var title = titleEle.text;
        var url = titleEle.attributes['href'];

        var divMeta = article.querySelector("div.meta");
        var authorEle = article.querySelectorAll("a")[0];
        var author = authorEle.querySelector("span").text;
        var profile = authorEle.querySelector("a").attributes["href"];
        var replyUserEle = article.querySelectorAll("a")[1];
        var lastReplyUser = replyUserEle.querySelector("span").text;
        var lastReplyTime = divMeta.querySelectorAll("span")[2].text;

        Feed homeFeed = Feed.fromJson({
          "avatar": avatar,
          "meta": meta,
          "commentsCount": commentsCount,
          "title": title,
          "url": url,
          "author": author,
          "profile": profile,
          "lastReplyUser": lastReplyUser,
          "lastReplyTime": lastReplyTime,
          "subCatagory": subCatagory,
          "subDescription": subDescription
        });
        feeds.add(homeFeed);
      }
      return feeds;
    }


    /// 摸鱼模式下获取小组列表
    static List<Groups> getGroupsByFishMode(Document doc) {
      Element basicGroupDiv = doc.querySelector("#sticky-sidebar > div > div:nth-child(7) > div.flex.flex-col.items-start");
      List<Element> basicGroupList = basicGroupDiv.querySelectorAll("a");
      List<Groups> groupsList = getGroupListByGroupEle(basicGroupList);

      Element moreGroupDiv = doc.querySelector("#sticky-sidebar > div > div:nth-child(7) > div.groups-stackmenu");
      List<Element> moreGroupList = moreGroupDiv.querySelectorAll("a");
      groupsList += getGroupListByGroupEle(moreGroupList);
      return groupsList;
    }

    static List<Groups> getGroupListByGroupEle(List<Element> groupEleList) {
      List<Groups> groupsList = [];
      for (var basicGroup in groupEleList) {
        List<Element> spanList = basicGroup.querySelectorAll("span");
        Element avatarSpan =  spanList[0].querySelector("img");
        String description = "";
        if (spanList.length == 4) {
          description  = spanList[3].text.trim();
        }

        Groups groups = Groups.fromJson({
          "name": spanList[1].text.trim(),
          "url": basicGroup.attributes['href'],
          "avatar": "https://www.geekhub.com/${avatarSpan.attributes['src']}",
          "description": description
        });
        groupsList.add(groups);
      }
      return groupsList;
    }

    /// 信息模式下获取小组列表
    static List<Groups> getGroupsByInfoMode(Document doc) {
      Element basicGroupDiv = doc.querySelector("#float-bar > div.p-3.pr-1.mt-5.box3.shadow-xs.border-transparent.text-xs > div.flex.flex-col.items-start");
      List<Element> basicGroupList = basicGroupDiv.querySelectorAll("a");
      List<Groups> groupsList = getGroupListByGroupEle(basicGroupList);

      Element moreGroupDiv = doc.querySelector("#float-bar > div.p-3.pr-1.mt-5.box3.shadow-xs.border-transparent.text-xs > div.groups-stackmenu > div");
      List<Element> moreGroupList = moreGroupDiv.querySelectorAll("a");

      groupsList += getGroupListByGroupEle(moreGroupList);

      return groupsList;
    }


    static String getCurrentDateStr() {
      final DateTime now = DateTime.now();
      return "${now.year}-${now.month}-${now.day}";
    }
}
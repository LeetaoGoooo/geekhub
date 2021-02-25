import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/model/feed.dart';
import 'package:geekhub/model/post.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;



class Api {

  /// 根据 url 获取 feed list
  static Future<List<Feed>> getFeedListByUrl(String url) async {
    var resp = await http.get(url);
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    Element feedDiv = doc.getElementById("home-feed-list");

    if (feedDiv.getElementsByTagName("article").length > 0) {
      return _getByInfoMode(doc);
    }
    return _getByFishMode(doc);
  }

  /// 根据 post id 获取详情
  static Future<Post> getPostByUrl(String url) async {
    print('request url:$url');
    var id = null;
    var regxp = RegExp(r'(\d+)');
    var matches = regxp.firstMatch(url);
    if (matches != null){
      id = matches.group(0);
    }
    var resp = await http.get('https://www.geekhub.com$url');
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    Element main = doc.getElementsByTagName("main")[0];
    var title = main.querySelectorAll("div>div")[1].text;
    var authorEle = main.querySelector("div.box6>div.flex");
    var author = authorEle.querySelector("div > img").attributes['title'];
    var avatar = authorEle.querySelector("div > img").attributes['src'];
    var publishTime = main.querySelectorAll('.flex-1>div.flex-row>div>span')[1].text;
    var content = main.querySelector("div.story").innerHtml;
    var metaEle = main.querySelectorAll("div>div>ol>li")[2].querySelector("a");
    var meta = {
      "name": metaEle.text,
      "url": metaEle.attributes['href']
    };
    var commentsEle = main.querySelectorAll('div.comment-list');
    if (id != null) {
      commentsEle = main.querySelectorAll('div#post-$id-comment-list>div.comment-list');
    }
    var navEle = main.querySelector("nav");
    var commentPage = 0;
    if (navEle != null) {
      commentPage = navEle.querySelectorAll("li").length;
    }
    var comments = [];
    for (var commentEle in commentsEle) {
        var commentId = commentEle.attributes['id'];
        var commentAvatar = commentEle.querySelector('.object-cover').attributes['src'];
        var spanList = commentEle.querySelectorAll('div.action-list-parent>div>div>span');
        // reply user and profile
        var authorEle = spanList[0].querySelector("a");
        var commentAuthor = authorEle.text;
        var commentProfile = authorEle.attributes['href'];
        // reply Time
        var replyTime = spanList[4].text;
        String order = spanList[6].text;
        var commentContent = commentEle.querySelector('div.comment-content').innerHtml;
        // upCount;
        int upCount = int.parse(commentEle.querySelector("span.star-count").text);
        comments.add({
          "id": commentId,
          "avatar": commentAvatar,
          "author": commentAuthor,
          "profile": commentProfile,
          "replyTime": replyTime,
          "order": order,
          "content": commentContent,
          "upCount": upCount,
        });
    }

    return Post.fromJson({
      "url":url,
      "avatar":avatar,
      "title":title,
      "author":author,
      "content":content,
      "meta":meta,
      "comments":comments,
      "commentPage":commentPage,
      "publishTime":publishTime
    });
  }


  /// 摸鱼模式
  static List<Feed> _getByFishMode(Document doc) {
    List<Feed> feeds = [];
    Element feedDiv = doc.getElementById("home-feed-list");

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

      var titleEle = feedEle.querySelector(
          "a.text-base");
      var title = titleEle.text;
      var url = titleEle.attributes['href'];

      var commentsCount = feedEle
          .querySelectorAll("div > div > div > a > span")[2]
          .text;

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
  static List<Feed> _getByInfoMode(Document doc) {
    List<Feed> feeds = [];
    Element feedDiv = doc.getElementById("home-feed-list");

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
}

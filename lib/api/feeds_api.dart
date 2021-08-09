import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/common/utils.dart';
import 'package:geekhub/model/auth_model.dart';
import 'package:geekhub/model/feed.dart';
import 'package:geekhub/model/post_body.dart';
import 'package:geekhub/model/post_header.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class FeedsApi {

  /// 根据 url 获取 feed list
  static Future<List<Feed>> getFeedListByUrl(String url) async {
    print("request url:$url");
    /// TODO 小组模式下 feedDiv 不存在
    var headers = await Utils.getHeaders();
    var resp = await http.get(Uri.parse(url),headers: headers);
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    Element feedDiv = doc.getElementById("e");

    if (feedDiv.getElementsByTagName("article").length > 0) {
      return Utils.getByInfoMode(doc);
    }
    return Utils.getByFishMode(doc);
  }

  /// 根据 post id 获取详情
  static Future<PostHeader> getPostByUrl(String url) async {
    var resp = await http.get(Uri.parse('https://www.geekhub.com$url'));
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    Element main = doc.getElementsByTagName("main")[0];
    var title = main.querySelectorAll("div>div")[1].text;
    var authorEle = main.querySelector("div.box6>div.flex");
    var author = authorEle.querySelector("div > img").attributes['title'];
    var avatar = authorEle.querySelector("div > img").attributes['src'];
    var publishTime =
        main.querySelectorAll('.flex-1>div.flex-row>div>span')[1].text;
    var content = main.querySelector("div.story").innerHtml;
    var metaEle = main.querySelectorAll("div>div>ol>li")[2].querySelector("a");
    var meta = {"name": metaEle.text, "url": metaEle.attributes['href']};

    return PostHeader.fromJson({
      "url": url,
      "avatar": avatar,
      "title": title,
      "author": author,
      "content": content,
      "meta": meta,
      "publishTime": publishTime
    });
  }

  /// 获取评论
  static Future<PostBody> getCommentsByUrl(String url, int page) async {
    var id = null;
    var regxp = RegExp(r'(\d+)');
    var matches = regxp.firstMatch(url);
    if (matches != null) {
      id = matches.group(0);
    }
    var headers = await Utils.getHeaders();

    var resp = await http.get(Uri.parse('https://www.geekhub.com$url?page=$page'),headers: headers);
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    Element main = doc.getElementsByTagName("main")[0];

    var commentsEle = main.querySelectorAll('div.comment-list');
    if (id != null) {
      commentsEle =
          main.querySelectorAll('div#post-$id-comment-list>div.comment-list');
    }

    var navEle = main.querySelector("nav");
    var commentPage = 1;
    if (navEle != null) {
      commentPage = navEle.querySelectorAll("li").length;
    }

    var comments = [];
    for (var commentEle in commentsEle) {
      var commentId = commentEle.attributes['id'];
      var commentAvatar =
          commentEle.querySelector('.object-cover').attributes['src'];
      var spanList =
          commentEle.querySelectorAll('div.action-list-parent>div>div>span');
      // reply user and profile
      var authorEle = spanList[0].querySelector("a");
      var commentAuthor = authorEle.text;
      var commentProfile = authorEle.attributes['href'];
      // reply Time
      var replyTime = spanList[4].text;
      String order = spanList[6].text;
      var commentContent =
          commentEle.querySelector('div.comment-content').innerHtml;
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
    return PostBody.fromJson({'totalPage': commentPage, 'comments': comments});
  }

  static Future<AuthModel> getAuth(String url) async {
    var headers = await Utils.getHeaders();
    var resp =
        await http.get(Uri.parse(url), headers: headers);
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    var formExist = doc.getElementsByClassName('simple_form');
    var form = formExist[0];
    if (form != null) {
      var input = form.querySelector('input');
      return new AuthModel(
          token: input.attributes['value'], cookie: resp.headers['set-cookie']);
    }
    List<Element> metas = doc.querySelectorAll('head>meta');
    for (var meta in metas) {
      if (meta.attributes.containsKey("name") &&
          meta.attributes['name'] == 'csrf-token') {
        return new AuthModel(
            token: meta.attributes['content'],
            cookie: resp.headers['set-cookie'].split(";")[0]);
      }
    }
  }
}

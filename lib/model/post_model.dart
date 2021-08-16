/// @file   :   post_model
/// @author :   leetao
/// @date   :   2021/8/14 5:10 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   普通帖子

class Post {
  String authenticityToken;
  String title;
  String content;
  String clubId;
  String shopId;

  Post({this.authenticityToken,this.title,this.content,this.clubId,this.shopId});


  Map toJson() {
    return {
      "authenticity_token": this.authenticityToken,
      "post[title]": this.title,
      "post[content]":this.content,
      "post[club_id]":this.clubId,
      "post[shop_id]":this.shopId
    };
  }

  Post.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    title = json['title'];
    content = json['content'];
    clubId = json['clubId'];
    shopId = json['shopId'];
  }
}


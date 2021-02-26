import 'package:geekhub/model/comment.dart';

class PostBody{
  int totalPage;
  List<Comment> comments;


  PostBody.fromJson(Map<String,dynamic> json) {
    if (json == null) return;
    totalPage = json['totalPage'];
    comments = Comment.listFromJson(json['comments']);
  }  
}
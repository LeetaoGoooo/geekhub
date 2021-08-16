import 'package:geekhub/common/constants.dart';
import 'package:geekhub/model/post_theme.dart';

/// @file   :   new_post_event
/// @author :   leetao
/// @date   :   2021/8/15 1:29 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   

abstract class NewPostEvent {

}

class PostThemeEvent extends NewPostEvent {
  PostTheme postTheme;
  PostThemeEvent({this.postTheme});
}

class CreatePostEvent extends NewPostEvent {
  PostType action;
  PostTheme postTheme;
  Map<String,String> post;
  CreatePostEvent({this.action,this.postTheme,this.post});
}
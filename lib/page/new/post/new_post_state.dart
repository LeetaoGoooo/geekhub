import 'package:geekhub/model/post_header.dart';
import 'package:geekhub/model/post_theme.dart';

/// @file   :   new_post_state
/// @author :   leetao
/// @date   :   2021/8/15 1:51 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   

abstract class NewPostState {

}

class NewPostInitState extends NewPostState {
  final PostTheme postTheme;
  NewPostInitState({this.postTheme});
}

class NewPostThemeState extends NewPostState {
  final PostTheme postTheme;
  NewPostThemeState({this.postTheme});
}

class NewPostingState extends NewPostState{
}

class NewPostSuccessState extends NewPostState{
  final String url;
  final PostHeader post;
  NewPostSuccessState({this.url,this.post});
}

class NewPostFailedState extends NewPostState {

}
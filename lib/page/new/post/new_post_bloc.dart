import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/post_api.dart';
import 'package:geekhub/common/constants.dart';
import 'package:geekhub/model/meta.dart';
import 'package:geekhub/model/post_header.dart';
import 'package:geekhub/model/post_model.dart';
import 'package:geekhub/model/user.dart';
import 'package:geekhub/page/new/new_post_event.dart';
import 'package:geekhub/page/new/new_post_state.dart';
import 'package:geekhub/repository/user_repository.dart';
import 'package:rxdart/rxdart.dart';

/// @file   :   new_post_bloc
/// @author :   leetao
/// @date   :   2021/8/15 1:55 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  NewPostBloc() : super(NewPostInitState(postTheme: Constants.POST_THEMES.first));


  @override
  Stream<NewPostState> mapEventToState(NewPostEvent event) async*{
    final currentState = state;
    print('event is $event currentState is $state');
    if (event is PostThemeEvent) {
      if (currentState is NewPostInitState) {
        yield NewPostThemeState(postTheme: currentState.postTheme);
      }
    }
    if (event is  CreatePostEvent) {
      try {
        String  url = await _publishPost(event.action, event.post);
        if (url != null) {

          var _post = event.post;
          var _postTheme = event.postTheme;
          User _user = await UserRepository().getUser();
          yield NewPostSuccessState(url: url,post:
          PostHeader(title: _post['title'],content: _post['content'],avatar: _user.avatar,author: _user.id,meta: Meta(name: _postTheme.name,url: _postTheme.url),publishTime: "Just Now"));
        }
      }catch(e) {
        print("create post failed,e:$e");
        yield NewPostFailedState();
      }
    }
  }


  Future<String> _publishPost(PostType action, Map post) async {
    if (action == PostType.post) {
      String url = await PostApi.createPost(Post.fromJson(post));
      if (url != null) {
        // "https://www.geekhub.com"
        return url.substring(23);
      }
    }
    return null;
  }

  @override
  Stream<Transition<NewPostEvent, NewPostState>> transformEvents(
      Stream<NewPostEvent> events,
      TransitionFunction<NewPostEvent, NewPostState> transitionFn,
      ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}
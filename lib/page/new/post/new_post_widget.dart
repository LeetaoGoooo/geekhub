import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geekhub/common/constants.dart';
import 'package:geekhub/model/post_theme.dart';
import 'package:geekhub/page/new/new_post_bloc.dart';
import 'package:geekhub/page/new/new_post_event.dart';
import 'package:geekhub/page/new/new_post_state.dart';
import 'package:geekhub/page/post/comment_bloc.dart';
import 'package:geekhub/page/post/comment_event.dart';
import 'package:geekhub/page/post/post_bloc.dart';
import 'package:geekhub/page/post/post_event.dart';
import 'package:geekhub/page/post/post_page.dart';

/// @file   :   new_post_widget
/// @author :   leetao
/// @date   :   2021/8/15 6:45 下午
/// @email  :   leetao94@gmail.com
/// @desc   :

class NewPostWidget extends StatefulWidget {

  @override
  _NewPostWidgetState createState() => _NewPostWidgetState();
}

class _NewPostWidgetState extends State<NewPostWidget> with AutomaticKeepAliveClientMixin{
  TextEditingController _titleController;
  TextEditingController _contentController;
  NewPostBloc _newPostBloc;
  String _selectedGroup = '1';

  @override
  void initState(){
    super.initState();
    _titleController = new TextEditingController();
    _contentController = new TextEditingController();
    _newPostBloc = BlocProvider.of<NewPostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<NewPostBloc, NewPostState>(
          listener: (BuildContext context, state) {
            print("state is $state");
            if (state is NewPostSuccessState) {
              Fluttertoast.showToast(
                  msg: '发布成功,将在3秒后跳转到帖子!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  fontSize: 16.0);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<PostBloc>(
                          create: (context) =>
                          PostBloc()..add(PostFetched(state.url))),
                      BlocProvider(
                          create: (context) =>
                          CommentBloc()..add(CommentFetched(state.url, 1)))
                    ],
                    child: PostPage(post: state.post),);
                }),
              );
            }
            if (state is NewPostFailedState) {
              Fluttertoast.showToast(
                  msg: '发布失败，请重试!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  fontSize: 16.0);
            }
          },
          child: Center(
              child: Card(
                elevation: 0.0,
                margin: const EdgeInsets.only(
                    top: 16.0, left: 8.0, right: 8.0, bottom: 64.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding:
                        const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: Text(
                          "请填写以下表单，编辑器支持 MarkDown，请勿发布垃圾信息",
                          style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        )),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, right: 16.0, bottom: 8.0),
                      child: TextFormField(
                        cursorColor: Constants.secondaryColor,
                        controller: _titleController,
                        decoration: InputDecoration(
                            labelText: '输入标题',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            prefixIcon: Icon(
                              Icons.title,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: TextFormField(
                        minLines: 6,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _contentController,
                        decoration: InputDecoration(
                            labelText: '说出你的故事...',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            prefixIcon: Icon(
                              Icons.create,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    Divider(),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
                        child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 40, right: 40, bottom: 15, top: 15),
                              labelText: "选择合适的小组",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10), // <--- this line
                              ),
                            ),
                            onChanged: (String value) {
                              if (value != _selectedGroup) {
                                setState(() {
                                  _selectedGroup = value;
                                });
                              }
                            },
                            value: _selectedGroup,
                            items: _getDropdownMenuItemList())),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Constants.secondaryColor),
                        onPressed: _publishPost,
                        label: Text('提交'),
                        icon: Icon(Icons.done),
                      ),
                    )
                  ],
                ),
              ))
    );
  }

  List<Widget> _getDropdownMenuItemList() {
    List<DropdownMenuItem<String>> menus = [];
    for (var key in Constants.POST_GROUPS.keys) {
      var item = DropdownMenuItem(
        value: key,
        child: Text(Constants.POST_GROUPS[key]),
      );
      menus.add(item);
    }
    return menus;
  }

  void _publishPost() {
    if (_titleController.value.text.trim().length == 0 ||
        _contentController.value.text.trim().length == 0) {
      Fluttertoast.showToast(
          msg: '存在必填信息为空',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }
    _newPostBloc
      ..add(CreatePostEvent(action: PostType.post, post: {
        "title": _titleController.value.text.trim(),
        "content": _contentController.value.text.trim(),
        "clubId": _selectedGroup,
        "shopId": "0"
      },postTheme: PostTheme(
          index: 0,
          url: "https://www.geekhub.com/posts/new",
          name: "话题",
          title: "发布话题")));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
    print("already dispose");
  }

  @override
  bool get wantKeepAlive => true;
}

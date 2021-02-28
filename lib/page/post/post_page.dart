import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geekhub/model/comment_action.dart';
import 'package:geekhub/model/post_header.dart';
import 'package:geekhub/page/post/comment_bloc.dart';
import 'package:geekhub/page/post/comment_event.dart';
import 'package:geekhub/page/post/comment_state.dart';
import 'package:geekhub/page/post/post_bloc.dart';
import 'package:geekhub/page/post/post_event.dart';
import 'package:geekhub/page/post/post_state.dart';
import 'package:geekhub/widget/loading_list.dart';
import 'package:geekhub/widget/post_body.dart';
import 'package:geekhub/widget/post_header.dart';

/// @file   :   post_page
/// @author :   leetao
/// @date   :   2/23/21 3:55 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   帖子详情页

class PostPage extends StatefulWidget {
  final PostHeader post;

  PostPage({this.post});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostPage> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  PostBloc _postBloc;
  CommentBloc _commentBloc;
  TextEditingController _commentController = new TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
    _commentBloc = BlocProvider.of<CommentBloc>(context);
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        HapticFeedback.heavyImpact(); // 震动反馈（暗示已经滑到底部了）
        _commentBloc.add(CommentLoadMore());
      }
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _commentDialog(null);
            },
            label: Icon(FontAwesomeIcons.comment)),
        body: RefreshIndicator(
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              // shrinkWrap: true,
              slivers: [
                SliverAppBar(
                  title: Text("主题详情"),
                ),
                BlocBuilder<PostBloc, PostState>(
                    // ignore: missing_return
                    builder: (context, state) {
                  if (state is PostInit) {
                    return SliverToBoxAdapter(
                        child: PostDetailHeader(widget.post));
                  }
                  if (state is PostSuccess) {
                    var topic = state.topic;
                    return SliverToBoxAdapter(child: PostDetailHeader(topic));
                  }
                  if (state is MakeCommentFailed) {
                    var topic = state.topic;
                    if (topic != null) {
                      return SliverToBoxAdapter(child: PostDetailHeader(topic));
                    }
                    return SliverToBoxAdapter(
                        child: Column(children: [
                      PostDetailHeader(widget.post),
                      Text("加载失败，请重新加载...")
                    ]));
                  }
                  if (state is MakeCommentSuccess) {
                    Fluttertoast.showToast(
                        msg: '评论成功',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return SliverToBoxAdapter(
                        child: PostDetailHeader(state.topic));
                  }
                  if (state is PostFailure) {
                    return SliverToBoxAdapter(
                        child: Column(children: [
                      PostDetailHeader(widget.post),
                      Text("加载失败，请重新加载...")
                    ]));
                  }
                }),
                BlocBuilder<CommentBloc, CommentState>(
                    // ignore: missing_return
                    builder: (context, state) {
                  print("CommentState is $state");
                  // return widget here based on BlocA's state
                  if (state is CommentSuccess) {
                    if (state.comment.totalPage == state.page) {
                      return PostDetailBody(state.comment, msg: '已经到底了...😊',callBack: _commentDialog,);
                    }
                    return PostDetailBody(state.comment,callBack: _commentDialog);
                  }

                  if (state is CommentLoading) {
                    if (state.comment == null) {
                      return SliverToBoxAdapter(child: LoadingList());
                    }
                    return PostDetailBody(state.comment, msg: '正在加载中...💪');
                  }
                  if (state is CommentFailure) {
                    if (state.comment == null) {
                      return Center(child: Text("加载失败...😭"));
                    }
                    return PostDetailBody(state.comment, msg: '加载失败...😭');
                  }
                  return SliverToBoxAdapter(child: LoadingList());
                }),
              ],
            ),
            onRefresh: () async {
              _postBloc.add(PostFetched(widget.post.url));
              _commentBloc.add(CommentFetched(widget.post.url, 1));
            }));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _commentDialog(replyToId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('说点什么'),
            content: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _commentController,
                      maxLines: null,
                      minLines: 6,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              RaisedButton(
                  color: Colors.blue,
                  child: Text("评论"),
                  onPressed: () {
                    // your code
                    _postBloc.add(CommentPost(CommentAction.fromJson({
                      "replyToId": replyToId == null ?'0':replyToId,
                      "content": _commentController.text.trim()
                    })));
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}

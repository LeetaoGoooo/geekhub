import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geekhub/common/constants.dart';
import 'package:geekhub/model/comment_action.dart';
import 'package:geekhub/model/post_header.dart';
import 'package:geekhub/model/user.dart';
import 'package:geekhub/page/login/login_bloc.dart';
import 'package:geekhub/page/login/login_event.dart';
import 'package:geekhub/page/login/login_page.dart';
import 'package:geekhub/page/post/comment_bloc.dart';
import 'package:geekhub/page/post/comment_event.dart';
import 'package:geekhub/page/post/comment_state.dart';
import 'package:geekhub/page/post/post_bloc.dart';
import 'package:geekhub/page/post/post_event.dart';
import 'package:geekhub/page/post/post_state.dart';
import 'package:geekhub/repository/user_repository.dart';
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
  String replyId;

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
                      SvgPicture.asset(
                        'assets/svg/loading_failed.svg',
                        height: 64,
                        width: 64,
                        semanticsLabel: '加载失败',
                      ),
                      Text("加载失败，请重新加载..."),
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
                    _commentController.clear();
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
                  print("CommentState is $state current replyToId:$replyId");
                  if (state is CommentSuccess) {
                    if (state.comment.totalPage == state.page) {
                      return PostDetailBody(
                        state.comment,
                        msg: '已经到底了...😊',
                        callBack: _commentDialog,
                      );
                    }
                    return PostDetailBody(state.comment,
                        callBack: _commentDialog);
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
                })
              ],
            ),
            onRefresh: () async {
              _postBloc.add(PostFetched(widget.post.url));
              _commentBloc.add(CommentFetched(widget.post.url, 1));
            }),
        bottomNavigationBar: Container(
          height: 80,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60.0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(232, 232, 232, 1),
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "说点什么呢...",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(186, 186, 186, 1),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _commentController.clear();
                              if (replyId != null) {
                                setState(() {
                                  replyId = null;
                                });
                              }
                            },
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                  width: 65.0,
                  height: 65.0,
                  decoration: BoxDecoration(
                    color: Constants.secondaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Constants.primaryColor),
                    onPressed: () async {
                      User _user = await new UserRepository().getUser();
                      if (_user == null) {
                        Fluttertoast.showToast(
                            msg: "请登录后评论!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            // backgroundColor: Colors.red,
                            // textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return BlocProvider<LoginBloc>(
                            create: (context) => LoginBloc()..add(AuthPage()),
                            child: LoginPage(),
                          );
                        }));
                      }
                      String replyToId = replyId == null ? '0' : replyId;
                      String comment = _commentController.text.trim();
                      setState(() {
                        replyId = null;
                      });
                      _commentController.clear();
                      _commentBloc.add(CommentPost(CommentAction.fromJson(
                          {"replyToId": replyToId, "content": comment})));
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;

  void _commentDialog(String replyToId, String author) {
    setState(() {
      replyId = replyToId;
    });
    String text = "@" + author.trim();
    _commentController.value = new TextEditingValue(text: text);
  }
}

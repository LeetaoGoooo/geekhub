import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/model/post_body.dart';
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
  int _currentPage = 1;
  ScrollController _scrollController = new ScrollController();
  PostBloc _postBloc;
  CommentBloc _commentBloc;

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
            child: Scrollbar(
              child: CustomScrollView(
                controller: _scrollController,
                shrinkWrap: true,
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
                        return PostDetailBody(state.comment, msg: '已经到底了...😊');
                      }
                      return PostDetailBody(state.comment);
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
            ),
            onRefresh: () async {
              _postBloc.add(PostFetched(widget.post.url));
            }));
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geekhub/model/post.dart';
import 'package:geekhub/page/post/post_bloc.dart';
import 'package:geekhub/page/post/post_event.dart';
import 'package:geekhub/page/post/post_state.dart';
import 'package:geekhub/widget/circle_avatar.dart';
import 'package:geekhub/widget/loading_list.dart';
import 'package:geekhub/widget/post_body.dart';
import 'package:geekhub/widget/post_header.dart';

/// @file   :   post_page
/// @author :   leetao
/// @date   :   2/23/21 3:55 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   帖子详情页

class PostPage extends StatefulWidget {
  final Post post;

  PostPage({this.post});

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostPage> with AutomaticKeepAliveClientMixin {
  int page = 1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("主题详情"),
        ),
        body: BlocProvider(
            create: (context) => PostBloc()..add(PostFetched(widget.post.url)),
            child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
              if (state is PostInit) {
                return Container(
                  child: Column(
                    children: [PostDetailHeader(widget.post), LoadingList()],
                  ),
                );
              }
              if (state is PostSuccess) {
                var post = state.post;
                return RefreshIndicator(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.only(
                                    left: 18.0, right: 18.0, top: 0),
                                child: Row(
                                  children: [
                                    CircleAvatarWithPlaceholder(
                                      imageUrl: post.avatar,
                                      size: 32,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "${post.author.trim()}",
                                                  ),
                                                  Text(
                                                    post.meta.name,
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${post.publishTime.substring(4)}',
                                                style: TextStyle(
                                                    color: Colors.grey[400]),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 6,left: 16),
                              child: Text(
                                post.title.trim(),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Divider(),
                            _getPostContentWidget(post.content),
                            Divider(),
                            PostDetailBody(post),
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      BlocProvider.of<PostBloc>(context).add(PostFetched(widget.post.url));
                    });
              }
              return Container(child: Text("加载失败..."));
            })));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _getPostContentWidget(String content) {
    var data = "";
    if (content != null && content.isNotEmpty) {
      data = content.trim();
    }
    return Html(
      data: data,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geekhub/api/api.dart';
import 'package:geekhub/model/comment.dart';
import 'package:geekhub/model/post.dart';

import 'circle_avatar.dart';

/// @file   :   post_body.dart
/// @author :   leetao
/// @date   :   2/23/21 8:08 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   post body 部分

class PostDetailBody extends StatefulWidget {
  final Post post;

  PostDetailBody(this.post);

  @override
  _PostDetailBodyState createState() => _PostDetailBodyState();
}

class _PostDetailBodyState extends State<PostDetailBody>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  bool _showToTopBtn = false; // 显示"返回到顶部"按钮
  final _scrollThreshold = 200.0;
  int _currentPage = 0;

  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // 监听是否滑到了页面底部
    _scrollController.addListener(_onScroll);
    setState(() {
      _currentPage = widget.post.currentPage;
      _comments = widget.post.comments;
    });
  }

  void _onScroll() async {
    print("滚动...");
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      HapticFeedback.heavyImpact(); // 震动反馈（暗示已经滑到底部了）
    }

    if (_scrollController.offset >= 400 && _showToTopBtn == false) {
      setState(() {
        _showToTopBtn = true;
      });
    } else if (_scrollController.offset < 400 && _showToTopBtn) {
      setState(() {
        _showToTopBtn = false;
      });
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (_currentPage < widget.post.commentPage) {
        var post =
            await Api.getPostByUrl('${widget.post.url}?${_currentPage + 1}');
        setState(() {
          _comments = _comments + post.comments;
          _currentPage += 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _comments.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildComment(_comments[index]);
          },
          controller: _scrollController,
        ),
        Visibility(
            visible: _showToTopBtn,
            child: Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.arrow_upward),
                  onPressed: () {
                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease);
                  }),
            ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildComment(Comment comment) {
    return Container(
        padding: EdgeInsets.only(left: 16.0, right: 18.0, top: 6),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatarWithPlaceholder(
                    imageUrl: comment.avatar,
                    size: 32,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                "${comment.author.trim()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  comment.replyTime.trim(),
                                  style: TextStyle(color: Colors.grey[400]),
                                ))
                          ]),
                      Text(comment.order,
                          style: TextStyle(color: Colors.grey[400])),
                    ],
                  ))
                ],
              ),
              Html(
                data: comment.content.trim(),
                onLinkTap: (String url) {
                  // TODO
                },
                style: {
                  "p": Style(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      fontSize: FontSize(15.0)),
                  "span": Style(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      fontSize: FontSize(15.0))
                },
              ),
              Row(
                children: [
                  TextButton.icon(
                    style: ButtonStyle(),
                    icon: Icon(
                      FontAwesomeIcons.reply,
                      size: 16,
                    ),
                    label: Text('评论'),
                    onPressed: () {},
                  ),
                  TextButton.icon(
                    style: ButtonStyle(),
                    icon: Icon(
                      FontAwesomeIcons.rocket,
                      size: 16,
                    ),
                    label: Text('上天(${comment.upCount})'),
                    onPressed: () {},
                  )
                ],
              ),
              Divider()
            ]));
  }
}

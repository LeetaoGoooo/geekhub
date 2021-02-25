import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/page/feed/feed_bloc.dart';
import 'package:geekhub/page/feed/feed_event.dart';
import 'package:geekhub/page/feed/feed_state.dart';

import 'feed_item.dart';

/// @file   :   topic_list_view.dart
/// @author :   leetao
/// @date   :   2/22/21 9:03 PM
/// @email  :   leetao94@gmail.com
/// @desc   :

class TopicListView extends StatefulWidget {
  final String tabKey;

  TopicListView(this.tabKey);

  @override
  _TopicListViewState createState() => _TopicListViewState();
}

class _TopicListViewState extends State<TopicListView>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  bool showToTopBtn = false; // 显示"返回到顶部"按钮

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // 监听是否滑到了页面底部
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        HapticFeedback.heavyImpact(); // 震动反馈（暗示已经滑到底部了）
      }

      if (_scrollController.offset >= 400 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      } else if (_scrollController.offset < 400 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc()..add(FeedFetched(widget.tabKey)),
      // ignore: missing_return
      child: BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
        if (state is FeedInit) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is FeedFailure) {
          return Center(
            child: Text("加载数据失败..."),
          );
        }
        if (state is FeedSuccess) {
          return Stack(
            children: [
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                // ignore: missing_return
                itemCount: state.feeds.length,
                itemBuilder: (BuildContext context, int index) {
                  return FeedItem(state.feeds[index]);
                },
                controller: _scrollController,
              ),
              Visibility(
                  visible: showToTopBtn,
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
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

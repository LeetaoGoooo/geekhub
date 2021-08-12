import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geekhub/common/constants.dart';
import 'package:geekhub/model/tabmodel.dart';
import 'package:geekhub/widget/topic_list_view.dart';

/// @file   :   home_page.dart
/// @author :   leetao
/// @date   :   2/23/21 9:36 AM
/// @email  :   leetao94@gmail.com
/// @desc   :   主页

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}


class _HomePageState extends State<HomePage>  with TickerProviderStateMixin{
  List<TabModel> tabs = TABS;

  // 定义底部导航 Tab
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: secondaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs.map((TabModel choice) {
              return Tab(
                text: choice.title,
              );
            }).toList(),
          ),
          elevation: defaultTargetPlatform == TargetPlatform.android
              ? 5.0
              : 0.0,

        ),
        body: TabBarView(
            controller: _tabController,
            children: tabs.map((TabModel choice) {
              return TopicListView(tabKey: choice.key);
            }).toList()
        )
    );
  }
}
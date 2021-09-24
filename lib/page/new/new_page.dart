import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/common/constants.dart';
import 'package:geekhub/page/new/new_post_bloc.dart';
import 'package:geekhub/page/new/new_post_widget.dart';

/// @file   :   new_post_page
/// @author :   leetao
/// @date   :   2021/8/15 11:20 上午
/// @email  :   leetao94@gmail.com
/// @desc   :

class NewPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPage>
    with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  TabController _tabController;
  String _title = "发布话题";
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: Constants.POST_THEMES.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Constants.secondaryColor,
            isScrollable: false,
            tabs: [
              for (final postTheme in Constants.POST_THEMES)
                Tab(text: postTheme.name)
            ],
            onTap: (int index) {
              if (_currentIndex != index) {
                setState(() {
                  _title = Constants.POST_THEMES[index].title;
                  _currentIndex = index;
                });
              }
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            BlocProvider(
                create: (BuildContext context) => NewPostBloc(), child: NewPostWidget()),
            NewPostWidget(),
            NewPostWidget(),
            NewPostWidget(),
            NewPostWidget(),
            NewPostWidget(),
            NewPostWidget()
          ],
        ));
  }


  @override
  bool get wantKeepAlive => true;


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    print("new post page already dispose");
  }
}

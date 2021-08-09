import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geekhub/page/groups/group_event.dart';
import 'package:geekhub/page/groups/group_state.dart';
import 'package:geekhub/widget/groups_grid.dart';
import 'package:geekhub/widget/groups_loading.dart';

import 'group_bloc.dart';

/// @file   :   group_page
/// @author :   leetao
/// @date   :   2021/8/7 9:40 下午
/// @email  :   leetao94@gmail.com
/// @desc   :

class GroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("小组"),
      ),
      body: RefreshIndicator(
        child: BlocProvider(
          create: (context) => GroupBloc()..add(GroupListInitEvent()),
          child: _groupListWidget(),
        ),
        onRefresh: () async {
          Future.delayed(Duration(seconds: 3));
          GroupBloc()..add(GroupListRefreshEvent());
        },
      ),
    );
  }

  Widget _groupListWidget() {
    return BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
      if (state is GroupListInitSuccess) {
        return GridGroups(state.groups);
      }
      if (state is GroupListInitFailed) {
        Fluttertoast.showToast(
            msg: '加载失败，尝试重新加载!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return _groupFailedWidget();
      }
      return GroupsLoading();
    });
  }

  Widget _groupFailedWidget() {
    return Container(
      child: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            GroupBloc()..add(GroupListRefreshEvent());
          }),
    );
  }
}

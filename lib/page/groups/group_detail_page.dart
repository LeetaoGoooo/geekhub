import 'package:flutter/material.dart';
import 'package:geekhub/model/groups.dart';
import 'package:geekhub/widget/topic_list_view.dart';

/// @file   :   group_detail_page
/// @author :   leetao
/// @date   :   2021/8/9 9:40 上午
/// @email  :   leetao94@gmail.com
/// @desc   :   

class GroupDetailPage extends StatelessWidget {
  final Groups group;

  const GroupDetailPage(this.group);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(group.name),),
      body: TopicListView(url: group.url)
    );
  }

}
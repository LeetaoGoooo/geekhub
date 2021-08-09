import 'package:flutter/material.dart';
import 'package:geekhub/model/groups.dart';
import 'package:geekhub/page/groups/group_detail_page.dart';
import 'package:geekhub/widget/topic_list_view.dart';

import 'circle_avatar.dart';

/// @file   :   groups_grid
/// @author :   leetao
/// @date   :   2021/8/8 3:44 下午
/// @email  :   leetao94@gmail.com
/// @desc   :

class GridGroups extends StatelessWidget {
  final List<Groups> groups;

  const GridGroups(this.groups);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                    return GroupDetailPage(groups[index]);
                // return TopicListView(url:groups[index].url);
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(245, 246, 250, 1),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatarWithPlaceholder(
                    imageUrl: groups[index].avatar,
                    size: 32,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    groups[index].name,
                  )
                ],
              ),
            ),
          );
        },
        itemCount: groups.length,
      ),
    );
  }
}

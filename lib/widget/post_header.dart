import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geekhub/model/post.dart';

import 'circle_avatar.dart';

/// @file   :   post_header
/// @author :   leetao
/// @date   :   2/23/21 4:34 PM
/// @email  :   leetao94@gmail.com
/// @desc   : post 的详情头部

class PostDetailHeader extends StatelessWidget {
  final Post post;

  const PostDetailHeader(this.post);

  @override
  Widget build(BuildContext context) {
    return Expanded(child:Container(
      padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(
          children: [
            CircleAvatarWithPlaceholder(
              imageUrl: post.avatar,
              size: 48,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        post.publishTime.trim().startsWith("发布于") ? post.publishTime.trim().substring(4): post.publishTime.trim(),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            post.title.trim(),
            softWrap: true,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Divider(),
      ]),
    ));
  }

  // ignore: missing_return
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

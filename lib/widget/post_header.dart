import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geekhub/model/post_header.dart';

import 'circle_avatar.dart';

/// @file   :   post_header
/// @author :   leetao
/// @date   :   2/23/21 4:34 PM
/// @email  :   leetao94@gmail.com
/// @desc   : post 的详情头部

class PostDetailHeader extends StatelessWidget {
  final PostHeader topic;

  const PostDetailHeader(this.topic);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
            child: Row(
              children: [
                CircleAvatarWithPlaceholder(
                  imageUrl: topic.avatar,
                  size: 32,
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
                                "${topic.author.trim()}",
                              ),
                              Text(
                                topic.meta.name,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            '${topic.publishTime.substring(4)}',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
        Padding(
          padding: EdgeInsets.only(top: 6, left: 16),
          child: Text(
            topic.title.trim(),
            softWrap: true,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Divider(),
        _getTopicContentWidget(topic.content),
        Divider(),
      ],
      // ))
    );
  }

  Widget _getTopicContentWidget(String content) {
    var data = "";
    if (content != null && content.isNotEmpty) {
      data = content.trim();
    }
    return Html(
      data: data,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/common/constants.dart';
import 'package:geekhub/model/feed.dart';
import 'package:geekhub/model/post_header.dart';
import 'package:geekhub/page/post/comment_bloc.dart';
import 'package:geekhub/page/post/comment_event.dart';
import 'package:geekhub/page/post/post_bloc.dart';
import 'package:geekhub/page/post/post_event.dart';
import 'package:geekhub/page/post/post_page.dart';

import 'circle_avatar.dart';

class FeedItem extends StatelessWidget {
  final Feed feed;

  const FeedItem(this.feed);

  @override
  Widget build(BuildContext context) {
    var post = PostHeader.fromJson({
      "url": feed.url,
      "author": feed.author,
      "title": feed.title,
      "meta": {"name": feed.meta.name, "url": feed.meta.url},
      "publishTime": feed.lastReplyTime,
      "avatar": feed.avatar
    });

    return new InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<PostBloc>(create: (context) => PostBloc()..add(PostFetched(post.url))),
                  BlocProvider(create: (context) => CommentBloc()..add(CommentFetched(post.url,1)))
                ],
                child: PostPage(post: post),
              );
            }),
          );
        },
        child: Container(
          color: Constants.primaryColor,
          padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 0),
          child: Column(children: [
            Row(
              children: [
                CircleAvatarWithPlaceholder(
                  imageUrl: feed.avatar,
                  size: 32,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(
                    "${feed.author}",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: TextButton(
                      child: Text(
                          (feed.meta.name == null ? "全部" : feed.meta.name)),
                      onPressed: () {},
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          feed.title,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.headline6,
                        )),
                        Align(
                            alignment: Alignment.centerRight,
                            child: ActionChip(
                                label: Text(feed.commentsCount.isNotEmpty
                                    ? feed.commentsCount
                                    : "0"),
                                onPressed: () {}))
                      ],
                    ),
                    Text(
                      '${feed.lastReplyTime} · 最后回复 ${feed.lastReplyUser}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ]),
            ),
            Divider()
          ]),
        ));
  }
}

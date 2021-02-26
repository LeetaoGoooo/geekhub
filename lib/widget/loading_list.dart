import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// @file   :   loading_list.dart
/// @author :   leetao
/// @date   :   2/23/21 5:19 PM
/// @email  :   leetao94@gmail.com
/// @desc   :   

class LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[300]
                : Colors.black12,
            highlightColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[100]
                : Colors.white70,
            child: Column(
              children: [0, 1, 2, 3, 4, 5, 6]
                  .map((_) => Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(4)),
                      child: Container(
                        width: double.infinity,
                        height: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            width: 22.0,
                            height: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(4)),
                          child: Container(
                            width: 40.0,
                            height: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(4)),
                          child: Container(
                            width: 40.0,
                            height: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(4)),
                          child: Container(
                            width: 40.0,
                            height: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.comment_outlined,
                          size: 16.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(4)),
                          child: Container(
                            width: 20.0,
                            height: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                ),
              ))
                  .toList(),
            ),
          )),
    );
  }
}

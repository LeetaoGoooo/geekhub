import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// @file   :   profile_loading
/// @author :   leetao
/// @date   :   2021/8/11 4:07 下午
/// @email  :   leetao94@gmail.com
/// @desc   :

class ProfileLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
            child: Shimmer.fromColors(
                baseColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[300]
                    : Colors.black12,
                highlightColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[100]
                    : Colors.white70,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: Container(
                    width: double.infinity,
                    height: 70.0,
                    color: Colors.white,
                  ),
                ))));
  }
}

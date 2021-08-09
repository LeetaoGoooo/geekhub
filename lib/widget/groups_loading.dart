import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// @file   :   groups_loading.dart
/// @author :   leetao
/// @date   :   2021/8/8 2:28 下午
/// @email  :   leetao94@gmail.com
/// @desc   :

class GroupsLoading extends StatelessWidget {
  final List<int> groups = [1,2,3,4,5,6,7,8];

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
            child: SingleChildScrollView(
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
                    onTap: () {},
                    child:_groupWidget(),
                  );
                },
                itemCount: groups.length,
              ),
            ),
          )),
    );
  }

  Widget _groupWidget() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 246, 250, 1),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
              child: Container(
            height: 32,
            width: 32,
            color: Colors.white,
          )),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}

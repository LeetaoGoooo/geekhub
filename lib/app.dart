import 'package:flutter/material.dart';
import 'package:geekhub/page/groups/group_page.dart';
import 'package:geekhub/page/home/home_page.dart';
import 'package:geekhub/page/profile/profile_page.dart';



class GeekHubApp extends StatefulWidget {
  @override
  _GeekHubAppState createState() => _GeekHubAppState();
}

class _GeekHubAppState extends State<GeekHubApp> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _children = [HomePage(),GroupsPage(),null,ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            currentIndex: _currentIndex,
            backgroundColor: colorScheme.surface,
            selectedItemColor: colorScheme.onSurface,
            unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
            selectedLabelStyle: textTheme.caption,
            unselectedLabelStyle: textTheme.caption,
            items: _getBottomNavigationBarItemList(),
          ),
          body: _children[_currentIndex],
    )
    );
  }


  List<BottomNavigationBarItem> _getBottomNavigationBarItemList() {
    return [
      new BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: '主页'
      ),
      new BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: '小组'
      ),
      new BottomNavigationBarItem(
        icon: Icon(Icons.shop),
        label: '店铺'),
      new BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: '我的')
    ];
  }
}


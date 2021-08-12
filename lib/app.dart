import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geekhub/page/groups/group_page.dart';
import 'package:geekhub/page/home/home_page.dart';
import 'package:geekhub/page/profile/profile_page.dart';
import 'package:geekhub/common/constants.dart';
import 'package:geekhub/widget/fab_bottom_appbar_item.dart';



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
    return MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Color.fromRGBO(245, 246, 250, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        home: Scaffold(
          // extendBody: true,
          bottomNavigationBar: FABBottomAppBar(
              onTabSelected: _selectedFab,
              selectedColor: secondaryColor,
              backgroundColor:colorScheme.surface,
              color: Colors.grey,
              notchedShape: CircularNotchedRectangle(),
              items: [
                FABBottomAppBarItem(iconData:Icons.home_outlined,text: "主页"),
                FABBottomAppBarItem(iconData: Icons.groups_outlined, text: "小组"),
                FABBottomAppBarItem(iconData: Icons.shop_outlined, text: "店铺"),
                FABBottomAppBarItem(iconData: Icons.person_outline, text: "我的")
              ],
            ),
          body: _children[_currentIndex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: secondaryColor,
            foregroundColor: primaryColor,
            onPressed: () {
              // Respond to button press
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        )
    );
  }


  void _selectedFab(int index) {
    setState(() {
      _currentIndex = index;
    });
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


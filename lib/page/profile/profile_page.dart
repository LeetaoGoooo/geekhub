import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geekhub/page/login/login_bloc.dart';
import 'package:geekhub/page/login/login_event.dart';
import 'package:geekhub/page/login/login_page.dart';
import 'package:geekhub/page/profile/profile_bloc.dart';
import 'package:geekhub/page/profile/profile_event.dart';
import 'package:geekhub/page/profile/profile_state.dart';
import 'package:geekhub/widget/circle_avatar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("我的")),
        body: BlocProvider(
          create: (context) => ProfileBloc()..add(ProfileFetch()),
          child: Column(children: [_aboutWidget(), _settingsWidget()]),
        ));
  }

  Widget _aboutWidget() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      print('curren state is $state');
      if (state is ProfileLoading) {
        return CircularProgressIndicator();
      }
      if (state is UnAuthed) {
        return Card(
            elevation: 0.0,
            margin: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return BlocProvider<LoginBloc>(
                    create: (context) => LoginBloc()..add(AuthPage()),
                    child: LoginPage(),
                  );
                }));
              },
              child: Text('登录'),
            ));
      }
      if (state is ProfileSuccess) {
        print("status :${state.status}");
        if (state.status != null) {
          String message = "签到成功!";
          if (!state.status) {
            message = "签到失败!";
          }
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        var user = state.user;
        return Column(
          children: [
            Card(
              elevation: 0.0,
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatarWithPlaceholder(
                    imageUrl: user.avatar, size: 32),
                title: Text(user.id),
                subtitle: Text("Gbit:${user.gbit.trim()}"),
                trailing: IconButton(
                  iconSize: 16,
                  icon: _trailingIconWidget(user.messageCount),
                  onPressed: () {
                    // 跳转到详情页面
                  },
                ),
              ),
            ),
            _checkInWidget(state.checked)
          ],
        );
      }
      return Card(
        elevation: 0.0,
        margin: const EdgeInsets.all(8.0),
        child: Center(child: Text("加载失败")),
      );
    });
  }

  Widget _checkInWidget(bool checked){
    if (checked) {
        return ElevatedButton.icon(
          icon: Icon(FontAwesomeIcons.check),
          label: Text("已签到"),
        );
      }
    return  ElevatedButton.icon(
      icon: Icon(FontAwesomeIcons.check),
      label: Text("签到"),
      onPressed: (){
        ProfileBloc()..add(CheckIn());
      },
    );

  }

  Widget _trailingIconWidget(int messageCount) {
    if (messageCount > 0) {
      return Badge(
        position: BadgePosition.topEnd(top: -6, end: -26),
        showBadge: true,
        padding: EdgeInsets.all(8),
        badgeColor: Colors.red,
        badgeContent: Text(
          messageCount.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        child: Icon(
          FontAwesomeIcons.arrowRight,
          size: 30,
        ),
      );
    }
    return Icon(FontAwesomeIcons.arrowRight);
  }

  Widget _settingsWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        Divider(),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.info,
          ),
          title: Text("用户协议"),
        ),
        Divider(),
        ListTile(leading: Icon(FontAwesomeIcons.comment), title: Text("意见反馈")),
        Divider(),
        ListTile(leading: Icon(FontAwesomeIcons.star), title: Text("去评分")),
        Divider()
      ],
    );
  }
}

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geekhub/common/constants.dart';
import 'package:geekhub/page/login/login_bloc.dart';
import 'package:geekhub/page/login/login_event.dart';
import 'package:geekhub/page/login/login_page.dart';
import 'package:geekhub/page/profile/profile_bloc.dart';
import 'package:geekhub/page/profile/profile_event.dart';
import 'package:geekhub/page/profile/profile_state.dart';
import 'package:geekhub/widget/circle_avatar.dart';
import 'package:geekhub/widget/profile_loading.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("我的")),
        body: BlocProvider(
          create: (_) => ProfileBloc()..add(ProfileFetch()),
          child: Column(children: [_aboutWidget(), _settingsWidget()]),
        ));
  }

  Widget _aboutWidget() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      print('current state is $state');
      if (state is ProfileFailed) {
        return Card(
          elevation: 0.0,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/svg/loading_failed.svg',
                height: 64,
                width: 64,
                semanticsLabel: '加载失败',
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh),
                label: Text("重新加载"),
                onPressed: () {
                  context.read<ProfileBloc>().add(ProfileFetch());
                },
              )
            ],
          ),
        );
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
      if (state is ProfileSuccess || state is CheckInState) {
        return _profileSuccessWidget(state, context);
      }
      return ProfileLoadingWidget();
    });
  }

  Widget _checkInWidget(bool checked, BuildContext context) {
    if (checked) {
      return ElevatedButton.icon(
        icon: Icon(FontAwesomeIcons.check),
        label: Text("已签到"),
      );
    }
    return ElevatedButton.icon(
      icon: Icon(FontAwesomeIcons.check),
      label: Text("签到"),
      onPressed: () {
        context.read<ProfileBloc>().add(CheckIn());
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
          )
          // child: Icon(
          //   FontAwesomeIcons.arrowRight,
          //   size: 30,
          // ),
          );
    }
    return Icon(FontAwesomeIcons.arrowRight);
  }

  Widget _settingsWidget() {
    return ListView(
      shrinkWrap: true,
      children: [
        Card(
          elevation: 0.0,
          color: Constants.primaryColor,
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.info,
            ),
            title: Text("用户协议"),
          ),
        ),
        Card(
            elevation: 0.0,
            color: Constants.primaryColor,
            child: ListTile(
                leading: Icon(FontAwesomeIcons.comment), title: Text("意见反馈"))),
        Card(
            elevation: 0.0,
            color: Constants.primaryColor,
            child: ListTile(
                leading: Icon(FontAwesomeIcons.star), title: Text("去评分")))
      ],
    );
  }

  Widget _profileSuccessWidget(ProfileState state, BuildContext context) {
    var user;
    var checked = false;
    if (state is ProfileSuccess) {
      user = state.user;
      checked = state.checked;
    }
    if (state is CheckInState) {
      user = state.user;
      checked = state.status;
      var message = "签到失败!";
      if (checked) {
        message = "签到成功!";
      }
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          // backgroundColor: Colors.red,
          // textColor: Colors.white,
          fontSize: 16.0);
    }
    return Column(
      children: [
        Card(
          elevation: 0.0,
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading:
                CircleAvatarWithPlaceholder(imageUrl: user.avatar, size: 32),
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
        _checkInWidget(checked, context)
      ],
    );
  }
}

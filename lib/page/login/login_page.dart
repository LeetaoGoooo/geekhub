import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geekhub/page/home/home_page.dart';
import 'package:geekhub/page/login/login_bloc.dart';
import 'package:geekhub/page/login/login_event.dart';
import 'package:geekhub/page/login/login_state.dart';

/// file        : login_page.dart
/// descrption  : 登录页面
/// date        : 2021/02/27 16:27:34
/// author      : Leetao

class LoginPage extends StatelessWidget {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _captchaController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.user),
                  helperText: '用户名/Email',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.lock),
                  helperText: '输入密码',
                ),
              ),
              BlocListener<LoginBloc, LoginState>(listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              }, child:
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                if (state is CaptchaLoading) {
                  return Container(height: 60, child: Text("验证码加载中..."));
                }
                if (state is CaptchaLoadSuccess) {
                  return InkWell(
                    onTap: () {
                      BlocProvider.of<LoginBloc>(context).add(CaptchaRefresh());
                    },
                    child: Container(
                        height: 80,
                        child: Image.network(
                          'https://www.geekhub.com/rucaptcha/?t=${DateTime.now().millisecondsSinceEpoch}',
                          fit: BoxFit.fill,
                          headers: {'cookie': state.authModel.cookie},
                        )),
                  );
                }
                return InkWell(
                  onTap: () {
                    BlocProvider.of<LoginBloc>(context).add(CaptchaRefresh());
                  },
                  child: Container(
                    height: 80,
                    child: Center(
                      child: Text("加载验证码失败，请点击图片重新刷新"),
                    ),
                  ),
                );
              })),
              TextFormField(
                controller: _captchaController,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.shieldAlt),
                  helperText: '输入验证码',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Respond to button press
                  var userName = _userNameController.text;
                  var password = _passwordController.text;
                  var captcha = _captchaController.text;
                  if (userName.trim().isEmpty ||
                      password.trim().isEmpty ||
                      captcha.trim().isEmpty) {
                    Fluttertoast.showToast(
                        msg: '存在必填信息为空',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        fontSize: 16.0);
                  } else {
                    print('登录...');
                    BlocProvider.of<LoginBloc>(context)
                        .add(UserLogin(userName, password, captcha));
                  }
                },
                child: Text('登录'),
              )
            ],
          )),
    );
  }
}

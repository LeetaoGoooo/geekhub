import 'package:geekhub/model/auth_model.dart';

abstract class LoginState {

}

/// 进入登录页面的初始状态
class AuthPageInit extends LoginState {
}

/// 登录加载状态
class CaptchaLoading extends LoginState {

}

class CaptchaLoadFailed extends LoginState {

}

/// 验证码准备条件
class CaptchaLoadSuccess extends LoginState{
  final AuthModel authModel;
  CaptchaLoadSuccess(this.authModel);
}


class Login extends LoginState {
  final String userName;
  final String password;
  final String captcha;

  Login(this.userName, this.password, this.captcha);
}


class LoginSuccess extends LoginState {

}

class LoginFailed extends LoginState {
  final AuthModel authModel;
  LoginFailed(this.authModel);
}
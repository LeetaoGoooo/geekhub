

abstract class LoginEvent {}

/// 认证页面初始化事件
class AuthPage extends LoginEvent {
}


class CaptchaRefresh extends LoginEvent {
  
}

class UserLogin extends LoginEvent {
    final String user;
    final String password;
    final String captcha;
  UserLogin(this.user, this.password, this.captcha);
}
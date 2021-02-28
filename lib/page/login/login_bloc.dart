import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/api.dart';
import 'package:geekhub/api/auth_api.dart';
import 'package:geekhub/api/user_api.dart';
import 'package:geekhub/model/auth_model.dart';
import 'package:geekhub/model/user.dart';
import 'package:geekhub/page/login/login_event.dart';
import 'package:geekhub/page/login/login_state.dart';
import 'package:geekhub/repository/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(AuthPageInit());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    final currentState = state;
    print('event is $event curentState is $state');
    if (event is AuthPage) {
      if (currentState is AuthPageInit || currentState is CaptchaLoadFailed) {
        try {
          yield CaptchaLoading();
          AuthModel authModel =
              await Api.getAuth('https://www.geekhub.com/users/sign_in');
          yield CaptchaLoadSuccess(authModel);
        } catch (_) {
          yield CaptchaLoadFailed();
        }
      }
    }
    if (event is UserLogin) {
      if (currentState is CaptchaLoadSuccess) {
        /// 完成登录 保存登录状态和 session 信息
        try {
          var session = await AuthApi.login(event.user, event.password,
              event.captcha, currentState.authModel);
          print('login session:$session');
          User user = await UserApi.getUserInfo(session);
          UserRepository userRepository = new UserRepository();
          await userRepository.setUser(user);
          yield LoginSuccess();
        } catch (e) {
          print(e);
          yield LoginFailed(currentState.authModel);
        }
      }
    }

    if (event is CaptchaRefresh) {
      try {
        yield CaptchaLoading();
        AuthModel authModel =
            await Api.getAuth('https://www.geekhub.com/users/sign_in');
        yield CaptchaLoadSuccess(authModel);
      } catch (_) {
        yield CaptchaLoadFailed();
      }
    }
  }

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}

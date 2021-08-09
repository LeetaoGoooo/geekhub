import 'package:flutter_test/flutter_test.dart';
import 'package:geekhub/api/feeds_api.dart';
import 'package:geekhub/api/auth_api.dart';
import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/model/auth_model.dart';

void main() {
  test('loginFailed', () async {
    try {
      await AuthApi.login('501257367@qq.com', '940419Leetao', 'ovpad', new AuthModel(cookie: 'xxx',token:'xxx'));
    } catch (e) {
      expect(e is AuthException, true);
    }
  });

  test('loginOk', () async {
      AuthModel authModel = await FeedsApi.getAuth('https://www.geekhub.com/users/sign_in');
      var token = await AuthApi.login('501257367@qq.com', '940419Leetao', 'fptax', authModel);
      expect(token.length > 0, true);
  });
}

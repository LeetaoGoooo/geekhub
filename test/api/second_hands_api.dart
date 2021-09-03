import 'package:geekhub/api/second_hands_api.dart';
import 'package:geekhub/common/exceptions.dart';
import 'package:test/test.dart';

/// @file   :   second_hands_api
/// @author :   leetao
/// @date   :   2021/8/21 3:59 下午
/// @email  :   leetao94@gmail.com
/// @desc   :

void main() {
  test("checksum FileNotFound", () async {
    try {
      String filePath = 'test.png';
      var body = await SecondHandsApi.getFileMd5Hash(filePath);
    } catch (e) {
      expect(e is FileNotFound, true);
    }
  });

  test("checksum no exception", () async {
    String filePath =
        '/Users/leetao/Workspace/ft/geekhub/assets/images/0]JOACPIYZY8HIZG6@9{04M.png';
    var body = await SecondHandsApi.getFileMd5Hash(filePath);
    expect(body['filename'] == '0]JOACPIYZY8HIZG6@9{04M.png', true);
    expect(body['byte_size'] == 41772, true);
    expect(body['checksum'] == "oDOTStaTrCwsiFeHdqdaoQ==", true);
  });
}

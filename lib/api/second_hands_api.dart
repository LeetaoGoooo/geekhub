import 'dart:convert';
import 'dart:io';

import 'package:geekhub/common/exceptions.dart';
import 'package:geekhub/common/utils.dart';
import 'package:geekhub/model/second_hands_model.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';

/// @file   :   second_hands_api
/// @author :   leetao
/// @date   :   2021/8/18 7:50 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   

class SecondHandsApi {

  /// 发布二手帖子
  static Future<String> createSecondHands(SecondHands secondHands) async {
    Map headers = await Utils.getHeaders();
    headers['content-type'] = 'application/x-www-form-urlencoded';
    headers['origin'] = 'https://www.geekhub.com';
    headers['referer'] = 'https://www.geekhub.com/second_hands/new';
    secondHands.authenticityToken = await getAuthenticityToken('https://www.geekhub.com/posts/new');
    var body = secondHands.toJson();
    var resp = await http.post(Uri.parse('https://www.geekhub.com/second_hands'),
        headers: headers,
        body: body);
    if (resp.statusCode != 302) {
      print(resp.statusCode);
      return null;
    }
    return resp.headers['location'];
  }

  static Future<String> getAuthenticityToken(String url) async {
    var headers = await Utils.getHeaders();
    var resp = await http.get(Uri.parse(url), headers: headers);
    if (resp.statusCode != 200) {
      throw new ApiException(resp.statusCode);
    }
    Document doc = parse(resp.body);
    var inputEle = doc.querySelector('#new_second_hand > input[type=hidden]');
    return inputEle.attributes['value'];
  }




  static Future<String> uploadImage(String filePath) async {


  }

  static Future<Map> uploadImageToGk(String filePath) async{
    Map body = {
      "blob": await getFileMd5Hash(filePath)
    };
    Map headers = await Utils.getHeaders();
    headers['content-type'] = 'application/json';
    headers['origin'] = 'https://www.geekhub.com';
    headers['referer'] = 'https://www.geekhub.com/second_hands/new';
    var resp = await http.post(Uri.parse('https://www.geekhub.com/rails/active_storage/direct_uploads'),
    headers: headers,
    body: body);
    if (resp.statusCode == 200) {
      var respJson =  jsonDecode(resp.body);
      return respJson['direct_upload'];
    }
    return null;
  }

  static Future<String> uploadImageToOss(Map body) async{
    var headers = body['headers'];
    headers['Origin'] = 'https://www.geekhub.com';
    headers['Referer'] = 'https://www.geekhub.com/';

    var resp = await http.put(Uri.parse(body['url']),
      headers: body['headers'],
      // body:
    );

  }

  static Future<Map> getFileMd5Hash(String filePath) async {
    var file = File(filePath);
    if (await file.exists()) {
      try {
        var hash = await md5.bind(file.openRead()).first;
        String checksum =  base64.encode(hash.bytes);
        return {
          "filename": basename(filePath),
          "content_type":"image/png",
          "byte_size": await file.length(),
          "checksum": checksum
        };
      } catch (exception) {
        throw new Md5Error(exception.toString());
      }
    }
    throw new FileNotFound("not found file");
  }
}
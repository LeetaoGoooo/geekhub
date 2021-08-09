import 'package:equatable/equatable.dart';

class User extends Equatable {
  String id;
  String gbit;
  // int checkDay;
  String sessionId;
  String avatar;
  int messageCount;

  User.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json['id'];
    gbit = json['gbit'];
    // checkDay = json['checkDay'];
    sessionId = json['sessionId'];
    avatar = json['avatar'];
    messageCount = json['messageCount'];
  }

  static List<User> listFromJson(List<dynamic> json) {
    return json == null
        ? List<User>()
        : json.map((value) => User.fromJson(value)).toList();
  }

  Map<String,dynamic> toJson() {
    return {
      "id":id,
      "gbit":gbit,
      "sessionId":sessionId,
      "avatar": avatar,
      "messageCount": messageCount
    };
  }

  @override
  List<Object> get props => [id];
}

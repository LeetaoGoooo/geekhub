/// @file   :   groups
/// @author :   leetao
/// @date   :   2021/8/7 7:39 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   小组

class Groups {
  String name;
  String url;
  String avatar;
  String description;

  Groups.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    name = json['name'];
    url = json['url'];
    avatar = json['avatar'];
    description = json['description'];
  }

  static List<Groups> listFromJson(List<dynamic> json) {
    return json == null
        ? List<Groups>()
        : json.map((value) => Groups.fromJson(value)).toList();
  }

  @override
  String toString() {
    return {
      "name": this.name,
      "url": this.url,
      "avatar": this.avatar,
      "description": this.description
    }.toString();
  }
}

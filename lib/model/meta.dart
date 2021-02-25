/// 节点
///  节点信息和节点 url
class Meta {
  int id;
  String name;
  String url;
  bool status; // 表示状态

  Meta.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json['id'];
    name = json['name'];
    url = json['url'];
    status = json['status'];
  }

  static List<Meta> listFromJson(List<dynamic> json) {
    return json == null
        ? List<Meta>()
        : json.map((value) => Meta.fromJson(value)).toList();
  }
  

  @override
  String toString() {
    return {
      "name": this.name,
      "url": this.url
    }.toString();
  }
}

/// @file   : TabModel
/// @author : leetao
/// @email  : leetao94cn@gmail.com
/// @desc   :  tab model

class TabModel {
  String title;
  String key;
  bool checked;

  TabModel(this.title, this.key, {this.checked});

  TabModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        key = json['key'],
        checked = json['checked'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'key': key,
        'checked': checked,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write(",\"key\":\"$key\"");
    sb.write(",\"checked\":\"$checked\"");
    sb.write('}');
    return sb.toString();
  }
}

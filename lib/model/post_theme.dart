/// @file   :   post_theme_model
/// @author :   leetao
/// @date   :   2021/8/15 1:34 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   

class PostTheme {
  int index;
  String url;
  String name;
  String title;

  PostTheme({this.index,this.url,this.name,this.title});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostTheme &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
import 'package:geekhub/model/groups.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geekhub/api/groups_api.dart';


/// @file   :   dart_repository
/// @author :   leetao
/// @date   :   2021/8/8 9:41 上午
/// @email  :   leetao94@gmail.com
/// @desc   :   

class GroupsRepository {

  Future<List<Groups>> getGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("groups")) {
      return Groups.listFromJson(prefs.getStringList("groups"));
    }
    return await refreshGroups();
  }

  Future<void> setGroups(List<Groups> groups) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> groupsStrList = [];
    groups.forEach((element) { groupsStrList.add(element.toString());});
    prefs.setStringList("groups",groupsStrList);
  }

  Future<List<Groups>> refreshGroups() async {
    List<Groups> groups = await GroupsApi.getGroupListByUrl('https://www.geekhub.com');
    await setGroups(groups);
    return groups;
  }

}
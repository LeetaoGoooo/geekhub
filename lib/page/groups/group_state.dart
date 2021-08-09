import 'package:geekhub/model/groups.dart';

/// @file   :   group_state
/// @author :   leetao
/// @date   :   2021/8/7 9:42 下午
/// @email  :   leetao94@gmail.com
/// @desc   :   


abstract class GroupState {

}

class GroupListInitState extends GroupState {

}

class GroupListLoadingState extends GroupState {

}

class GroupListInitFailed extends GroupState {

}

class GroupListInitSuccess extends GroupState {
  final List<Groups> groups;
  GroupListInitSuccess(this.groups);
}
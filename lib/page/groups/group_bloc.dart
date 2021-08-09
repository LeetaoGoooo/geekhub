import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/groups_api.dart';
import 'package:geekhub/model/groups.dart';
import 'package:geekhub/page/groups/group_state.dart';
import 'package:rxdart/rxdart.dart';

import 'group_event.dart';

/// @file   :   group_bloc
/// @author :   leetao
/// @date   :   2021/8/8 9:21 上午
/// @email  :   leetao94@gmail.com
/// @desc   :

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupListInitState());

  @override
  Stream<GroupState> mapEventToState(GroupEvent event) async* {
    final currentState = state;
    print('event is $event curentState is $state');
    if (event is GroupListInitEvent) {
      try {
        yield GroupListLoadingState();
        List<Groups> groupList =
            await GroupsApi.getGroupListByUrl('https://www.geekhub.com');
        yield GroupListInitSuccess(groupList);
      } catch (e) {
        print("get group list failed:$e");
        yield GroupListInitFailed();
      }
    }
  }

  @override
  Stream<Transition<GroupEvent, GroupState>> transformEvents(
    Stream<GroupEvent> events,
    TransitionFunction<GroupEvent, GroupState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}

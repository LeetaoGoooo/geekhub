import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/api/auth_api.dart';
import 'package:geekhub/common/utils.dart';
import 'package:geekhub/model/user.dart';
import 'package:geekhub/page/profile/profile_event.dart';
import 'package:geekhub/page/profile/profile_state.dart';
import 'package:geekhub/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInit());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    final currentState = state;
    print("mapEventToState current state is $currentState");
    bool checked = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("checkIn")) {
      String lastCheckInDateStr = prefs.getString("checkIn");
      if (lastCheckInDateStr == Utils.getCurrentDateStr()) {
        checked = true;
      }
    }

    if (event is ProfileFetch) {
      if (currentState is ProfileInit) {
        try {
          yield ProfileLoading();
          User _user = await new UserRepository().getUser();
          if (_user == null) {
            yield UnAuthed();
            return;
          }
          yield ProfileSuccess(_user, checked);
          User _refreshUser =
              await new UserRepository().refreshUser(_user.sessionId);
          yield ProfileSuccess(_refreshUser, checked);
        } catch (e) {
          print(e);
          yield ProfileFailed();
        }
      }
    }
    if (event is ProfileRefresh) {
      if (currentState is ProfileFailed) {
        try {
          yield ProfileLoading();
          User _user = await new UserRepository().getUser();
          if (_user == null) {
            yield UnAuthed();
            return;
          }
          yield ProfileSuccess(_user, checked);
        } catch (_) {
          yield ProfileFailed();
        }
      }
      if (currentState is ProfileSuccess) {
        try {
          yield ProfileLoading(user: currentState.user);
          User _user = await new UserRepository().getUser();
          if (_user == null) {
            yield UnAuthed();
            return;
          }
          yield ProfileSuccess(_user, checked);
        } catch (_) {
          yield ProfileFailed(user: currentState.user);
        }
      }
    }
    if (event is CheckIn) {
      print("current event is $event");
      User _user = await new UserRepository().getUser();
      bool checkStatus = await AuthApi.checkIn();
      print("checkStatus: $checkStatus");
      if (checkStatus) {
        prefs.setString("checkIn", Utils.getCurrentDateStr());
      }
      yield CheckInState(_user, checkStatus);
      return;
    }
  }

  @override
  Stream<Transition<ProfileEvent, ProfileState>> transformEvents(
      Stream<ProfileEvent> events,
      TransitionFunction<ProfileEvent, ProfileState> transitionFn,
      ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
}

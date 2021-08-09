import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geekhub/model/user.dart';
import 'package:geekhub/page/profile/profile_event.dart';
import 'package:geekhub/page/profile/profile_state.dart';
import 'package:geekhub/repository/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfiletInit());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    final currentState = state;
    print("mapEventToState current state is $currentState");
    if (event is ProfileFetch) {

      if (currentState is ProfiletInit) {
        try {
          yield ProfileLoading();
          User _user = await new UserRepository().getUser();
          if (_user == null) {
            yield UnAuthed();
            return;
          }
          yield ProfileSuccess(_user);
          User _refreshUser = await new UserRepository().refreshUser(_user.sessionId);
          yield ProfileSuccess(_refreshUser);
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
          yield ProfileSuccess(_user);
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
          yield ProfileSuccess(_user);
        } catch (_) {
          yield ProfileFailed(user: currentState.user);
        }
      }
    }
  }
}

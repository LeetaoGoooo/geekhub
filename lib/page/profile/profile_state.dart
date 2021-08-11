
import 'package:geekhub/model/user.dart';

abstract class ProfileState {

}

class ProfileInit extends ProfileState{

}

class UnAuthed extends ProfileState {

}


class ProfileSuccess extends ProfileState {
  final User user;
  final bool checked;
  ProfileSuccess(this.user,this.checked);
}


class ProfileFailed extends ProfileState {
  final User user;
  ProfileFailed({this.user});
}

class ProfileLoading extends ProfileState {
  final User user;
  ProfileLoading({this.user});
}

class CheckInState extends ProfileState {
  final User user;
  final bool status;
  CheckInState(this.user,this.status);
}
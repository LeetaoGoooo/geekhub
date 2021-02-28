
import 'package:geekhub/model/user.dart';

abstract class ProfileState {

}

class ProfiletInit extends ProfileState{

}

class UnAuthed extends ProfileState {

}


class ProfileSuccess extends ProfileState {
  final User user;
  ProfileSuccess(this.user);
}


class ProfileFailed extends ProfileState {
  final User user;
  ProfileFailed({this.user});
}

class ProfileLoading extends ProfileState {
  final User user;
  ProfileLoading({this.user});
}
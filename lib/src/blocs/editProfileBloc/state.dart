import 'package:equatable/equatable.dart';
import 'package:resman_mobile_customer/src/models/userModel.dart';

abstract class EditProfileBlocState extends Equatable {
  EditProfileBlocState([List props = const []]) : super(props);
}

class EditProfileBlocInitialize extends EditProfileBlocState {
  final UserModel currentUser;

  EditProfileBlocInitialize(this.currentUser) : super([currentUser]);

  @override
  String toString() => 'EditProfileBlocInitialize (${currentUser.username})';
}

class EditProfileBlocUploadingAvatar extends EditProfileBlocState {
  @override
  String toString() => 'EditProfileBlocUploadingAvatar';
}

class EditProfileBlocUploadedAvatar extends EditProfileBlocState {
  @override
  String toString() => 'EditProfileBlocUploadedAvatar';
}

class EditProfileBlocSaving extends EditProfileBlocState {
  final UserModel currentUser;
  final String newFullName;
  final DateTime newBirthday;
  final String newEmail;

  EditProfileBlocSaving(
      this.currentUser, this.newFullName, this.newBirthday, this.newEmail)
      : super([currentUser, newFullName, newBirthday, newEmail]);

  @override
  String toString() =>
      'EditProfileBlocSaving ${currentUser.username} ($newFullName, $newEmail, $newBirthday)';
}

class EditProfileBlocSaved extends EditProfileBlocState {
  final UserModel savedUser;

  EditProfileBlocSaved(this.savedUser) : super([savedUser]);

  @override
  String toString() => 'EditProfileBlocSaved';
}

class EditProfileBlocSaveFailure extends EditProfileBlocState {
  final String error;

  EditProfileBlocSaveFailure(this.error) : super([error]);

  @override
  String toString() => 'EditProfileBlocSaveFailure (error: $error)';
}

class EditProfileBlocUploadAvatarFailure extends EditProfileBlocState {
  final String error;

  EditProfileBlocUploadAvatarFailure(this.error) : super([error]);

  @override
  String toString() => 'EditProfileBlocUploadAvatarFailure (error: $error)';
}

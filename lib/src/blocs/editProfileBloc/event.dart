import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/models/userModel.dart';

abstract class EditProfileBlocEvent extends Equatable {
  EditProfileBlocEvent([List props = const []]) : super(props);
}

class SaveNewProfile extends EditProfileBlocEvent {
  final UserModel currentUser;
  final String newFullName;
  final DateTime newBirthday;
  final String newEmail;
  final String newPhoneNumber;
  final File newAvatar;
  final List<Address> newAddresses;

  SaveNewProfile(this.currentUser, this.newFullName, this.newBirthday,
      this.newEmail, this.newAvatar, this.newAddresses, this.newPhoneNumber)
      : super([currentUser, newFullName, newBirthday, newEmail, newAvatar, newAddresses, newPhoneNumber]);

  @override
  String toString() => 'SaveNewProfile';
}

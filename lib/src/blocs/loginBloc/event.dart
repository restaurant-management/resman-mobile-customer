import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginButtonPressed extends LoginEvent {
  final String usernameOrEmail;
  final String password;

  LoginButtonPressed({@required this.usernameOrEmail, @required this.password})
      : super([usernameOrEmail, password]);

  @override
  String toString() =>
      'LoginButtonPressed { username: $usernameOrEmail, password: $password }';
}

class InitializeLoginForm extends LoginEvent{
  @override
  String toString() => 'InitializeLoginForm';
}

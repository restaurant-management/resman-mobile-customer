import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../repositories/repository.dart';
import '../authenticationBloc/bloc.dart';
import '../authenticationBloc/event.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Repository _repository = Repository.instance;
  AuthenticationBloc authenticationBloc = AuthenticationBloc();

  LoginBloc();

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await _repository.authenticate(
            usernameOrEmail: event.usernameOrEmail, password: event.password);
        authenticationBloc.dispatch(LoggedIn(event.usernameOrEmail, token));
      } catch (e) {
        yield LoginFailure(error: e.toString());
        yield LoginInitial();
      }
    }

    if (event is InitializeLoginForm) {
      yield LoginInitial();
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/changePasswordBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/changePasswordBloc/state.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordBlocEvent, ChangePasswordBlocState> {
  final Repository _repository = Repository();

  @override
  ChangePasswordBlocState get initialState => ChangePasswordBlocInitialize();

  @override
  Stream<ChangePasswordBlocState> mapEventToState(
      ChangePasswordBlocEvent event) async* {
    if (event is ChangePasswordEvent) {
      yield ChangePasswordBlocChanging();
      try {
        await _repository.changeUserPassword(
            event.user, event.oldPassword, event.newPassword);
        yield ChangePasswordBlocChanged();
      } catch (e) {
        yield ChangePasswordBlocFailure(e.toString());
      }
    }
  }
}

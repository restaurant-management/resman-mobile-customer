import 'package:bloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/event.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';

import 'event.dart';
import 'state.dart';

class EditProfileBloc extends Bloc<EditProfileBlocEvent, EditProfileBlocState> {
  final Repository _repository = Repository();
  final CurrentUserBloc _currentUserBloc = CurrentUserBloc();

  @override
  EditProfileBlocState get initialState =>
      EditProfileBlocInitialize(_repository.currentUser);

  @override
  Stream<EditProfileBlocState> mapEventToState(
      EditProfileBlocEvent event) async* {
    if (event is SaveNewProfile) {
      var newAvatarUrl;
      if (event.newAvatar != null) {
        yield EditProfileBlocUploadingAvatar();
        try {
          newAvatarUrl = await _repository.uploadAvatar(
              event.newAvatar, event.currentUser.username);
          yield EditProfileBlocUploadedAvatar();
        } catch (e) {
          EditProfileBlocUploadAvatarFailure(e.toString());
        }
      }
      yield EditProfileBlocSaving(event.currentUser, event.newFullName,
          event.newBirthday, event.newEmail);
      try {
        var savedUser = await _repository.saveProfile(
            fullName: event.newFullName ?? '',
            email: event.newEmail,
            birthday: event.newBirthday,
            avatar: newAvatarUrl ?? event.currentUser.avatar,
            addresses: event.newAddresses,
            phoneNumber: event.newPhoneNumber);
        yield EditProfileBlocSaved(savedUser);
        _currentUserBloc.dispatch(FetchCurrentUserProfile());
      } catch (e) {
        yield EditProfileBlocSaveFailure(e.toString());
      }
    }
  }
}

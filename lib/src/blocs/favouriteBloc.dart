import 'package:bloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/favouriteDishesBloc.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';

class FavouriteBloc extends Bloc<FavouriteBlocEvent, FavouriteBlocState> {
  Repository _repository = Repository();
  CurrentUserBloc _currentUserBloc = CurrentUserBloc();
  FavouriteDishesBloc _favouriteDishesBloc = FavouriteDishesBloc();

  @override
  FavouriteBlocState get initialState => FavouriteBlocInitialize();

  @override
  Stream<FavouriteBlocState> mapEventToState(FavouriteBlocEvent event) async* {
    if (event is FavouriteDish) {
      yield FavouriteBlocLoading();
      try {
        yield FavouriteBlocSuccess(
            await _repository.favouriteDish(event.dishId));
        _currentUserBloc.dispatch(FetchCurrentUserProfile());
        _favouriteDishesBloc.dispatch(FetchFavouriteDishes());
        
      } catch (e) {
        yield FavouriteBlocFailure(e.toString());
      }
    }

    if (event is UnFavouriteDish) {
      yield FavouriteBlocLoading();
      try {
        yield FavouriteBlocSuccess(
            await _repository.unFavouriteDish(event.dishId));
        _currentUserBloc.dispatch(FetchCurrentUserProfile());
        _favouriteDishesBloc.dispatch(FetchFavouriteDishes());
      } catch (e) {
        yield FavouriteBlocFailure(e.toString());
      }
    }

    yield FavouriteBlocInitialize();
  }
}

// ============ EVENT ============//

abstract class FavouriteBlocEvent {}

class FavouriteDish extends FavouriteBlocEvent {
  final int dishId;

  FavouriteDish(this.dishId);
  @override
  String toString() => 'FavouriteDish ($dishId)';
}

class UnFavouriteDish extends FavouriteBlocEvent {
  final int dishId;

  UnFavouriteDish(this.dishId);
  @override
  String toString() => 'UnFavouriteDish ($dishId)';
}

// ============ STATE ============//

abstract class FavouriteBlocState {}

class FavouriteBlocInitialize extends FavouriteBlocState {
  @override
  String toString() => 'FavouriteBlocInitialize';
}

class FavouriteBlocLoading extends FavouriteBlocState {
  @override
  String toString() => 'FavouriteBlocLoading';
}

class FavouriteBlocSuccess extends FavouriteBlocState {
  final String message;

  FavouriteBlocSuccess(this.message);
  @override
  String toString() => 'FavouriteBlocSuccess ($message)';
}

class FavouriteBlocFailure extends FavouriteBlocState {
  final String message;

  FavouriteBlocFailure(this.message);
  @override
  String toString() => 'FavouriteBlocInitialize ($message)';
}

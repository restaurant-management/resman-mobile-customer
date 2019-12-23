import 'package:bloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/blocBase.dart';
import 'package:resman_mobile_customer/src/models/dishModal.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';

class FavouriteDishesBloc
    extends Bloc<FavouriteDishesEvent, FavouriteDishesState> {
  static FavouriteDishesBloc _singleton;

  FavouriteDishesBloc._internal();

  factory FavouriteDishesBloc() {
    if (_singleton == null) {
      _singleton = FavouriteDishesBloc._internal();
      _singleton.dispatch(FetchFavouriteDishes());
    }

    return _singleton;
  }

  final Repository _repository = Repository();

  List<DishModal> _favouriteDishes = [];

  List<DishModal> get favouriteDishes => _favouriteDishes;

  @override
  FavouriteDishesState get initialState => FavouriteDishesInitialize();

  @override
  Stream<FavouriteDishesState> mapEventToState(
      FavouriteDishesEvent event) async* {
    if (event is FetchFavouriteDishes) {
      yield FavouriteDishesFetching();

      try {
        _favouriteDishes = await _repository.getFavouriteDishes();
        yield FavouriteDishesFetchSuccess(_favouriteDishes);
      } catch (e) {
        yield FavouriteDishesFetchFailure(e.toString());
      }
    }
  }
}

// ============ EVENT ============//

abstract class FavouriteDishesEvent extends BlocEventBase {}

class FetchFavouriteDishes extends FavouriteDishesEvent {}

// ============ STATE ============//

abstract class FavouriteDishesState extends BlocStateBase {}

class FavouriteDishesInitialize extends FavouriteDishesState {}

class FavouriteDishesFetching extends FavouriteDishesState {}

class FavouriteDishesFetchSuccess extends FavouriteDishesState {
  final List<DishModal> favouriteDishes;

  FavouriteDishesFetchSuccess(this.favouriteDishes);
  @override
  String toString() => '$runtimeType (${favouriteDishes.length} dishes)';
}

class FavouriteDishesFetchFailure extends BlocErrorStateBase
    implements FavouriteDishesState {
  FavouriteDishesFetchFailure(String error) : super(error);
}

import 'package:bloc/bloc.dart';
import 'package:resman_mobile_customer/src/models/dailyDish.dart';
import '../../repositories/repository.dart';

import 'event.dart';
import 'state.dart';

class DailyDishBloc extends Bloc<DailyDishEvent, DailyDishState> {
  final Repository _repository = Repository();

  List<DailyDish> _listDailyDish = [];
  List<DailyDish> get listDailyDish => _listDailyDish;

  DailyDishBloc._internal();

  static DailyDishBloc _singleton;

  factory DailyDishBloc() {
    if (_singleton == null) {
      _singleton = DailyDishBloc._internal();
      _singleton.dispatch(FetchDailyDish());
    }

    return _singleton;
  }

  @override
  DailyDishState get initialState => DailyDishInitialized();

  @override
  Stream<DailyDishState> mapEventToState(DailyDishEvent event) async* {
    if (event is FetchDailyDish) {
      yield DailyDishFetching();
      try {
        _listDailyDish = await _repository.fetchAllDishToday();
        yield DailyDishFetched(_listDailyDish);
      } catch (e) {
        yield DailyDishFetchFailure(e.toString());
      }
    }
  }
}

import 'package:equatable/equatable.dart';

import '../enums/daySession.dart';
import 'dishModal.dart';

class DailyDish extends Equatable {
  DateTime _day;
  DaySession _session;
  int _storeId;
  DishModal _dish;
  int _confirmBy;
  DateTime _confirmAt;

  DateTime get day => _day;

  DaySession get session => _session;

  int get storeId => _storeId;

  DishModal get dish => _dish;

  int get confirmBy => _confirmBy;

  DateTime get confirmAt => _confirmAt;

  DailyDish.fromJson(Map<String, dynamic> parsedJson) {
    _day =
    parsedJson['day'] != null ? DateTime.tryParse(parsedJson['day']) : null;
    _session = DaySession(parsedJson['session']);
    _storeId = parsedJson['storeId'];
    _confirmBy = parsedJson['confirmBy'];
    _confirmAt = parsedJson['confirmAt'] != null
        ? DateTime.tryParse(parsedJson['confirmAt'])
        : null;
    _dish = DishModal.fromJson(parsedJson['dish']);
  }
}

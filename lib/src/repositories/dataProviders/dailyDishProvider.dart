import 'package:resman_mobile_customer/src/repositories/dataProviders/graphClient.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphQuery.dart';

import '../../models/dailyDish.dart';

class DailyDishProvider {
  Future<List<DailyDish>> getAllDishToday(int storeId) async {
    final data =
        await (GraphClient()..addBody(GraphQuery.todayDish(storeId))).connect();

    return (data['todayDish'] as List<dynamic>)
        .map((e) => DailyDish.fromJson(e))
        .toList();
  }
}

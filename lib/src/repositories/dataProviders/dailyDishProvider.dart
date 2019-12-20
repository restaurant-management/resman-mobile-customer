import 'dart:convert';

import 'package:http/http.dart';

import '../../models/dailyDish.dart';

class DailyDishProvider {
  static String apiUrl = 'http://resman-web-admin-api.herokuapp.com';
  Client client = Client();
  Future<List<DailyDish>> getAllDishToday() async {
    final response = await client.get('$apiUrl/api/daily_dishes/today?storeId=1');
    if (response.statusCode == 200) {
      List<DailyDish> result = [];
      List<dynamic> list = jsonDecode(response.body);
      for (int i = 0; i < list.length; i++) {
        var dailyDish = DailyDish.fromJson(list[i]);
        result.add(dailyDish);
      }
      return result;
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw Exception(message);
      throw Exception('Tải danh sách món ăn thất bại.');
    }
  }
}

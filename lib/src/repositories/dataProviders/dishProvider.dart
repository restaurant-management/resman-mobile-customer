import 'dart:convert';

import 'package:http/http.dart';
import 'package:resman_mobile_customer/src/models/comment.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphClient.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphQuery.dart';
import '../../models/dishModal.dart';

class DishProvider {
  static String apiUrl = 'https://restaurant-management-server.herokuapp.com';
  Client client = Client();

  Future<DishModal> getDishDetail(int dishId) async {
    final response = await client.get('$apiUrl/api/dishes/$dishId');
    if (response.statusCode == 200) {
      return DishModal.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Tải thông tin món ăn thất bại.');
    }
  }

  Future<List<DishModal>> getAll() async {
    final response = await client.get('$apiUrl/api/dishes/');
    if (response.statusCode == 200) {
      List<DishModal> result = [];
      List<dynamic> list = jsonDecode(response.body);
      for (int i = 0; i < list.length; i++) {
        var dish = DishModal.fromJson(list[i]);
        result.add(dish);
      }
      return result;
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Tải danh sách món ăn thất bại.');
    }
  }

  Future<List<Comment>> getComments(int dishId) async {
    final data = await (GraphClient()
          ..addBody(GraphQuery.getAllDishComment(dishId)))
        .connect();

    return (data['dishComments'] as List<dynamic>)
        .asMap()
        .map((index, item) {
          return MapEntry(index, Comment.fromJson(item));
        })
        .values
        .toList();
  }

  Future<Comment> createComment(String token, int dishId, String content,
      [double rating]) async {
    final data = await (GraphClient()
          ..authorization(token)
          ..addBody(GraphQuery.createComment(dishId, content, rating)))
        .connect();

    return Comment.fromJson(data['createComment']);
  }

  Future<String> favourite(String token, int dishId) async {
    final data = await (GraphClient()
          ..authorization(token)
          ..addBody(GraphQuery.favouriteDish(dishId)))
        .connect();

    return data['favouriteDish'];
  }

  Future<String> unFavourite(String token, int dishId) async {
    final data = await (GraphClient()
          ..authorization(token)
          ..addBody(GraphQuery.unFavouriteDish(dishId)))
        .connect();

    return data['unFavouriteDish'];
  }
}

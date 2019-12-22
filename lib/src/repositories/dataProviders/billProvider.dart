import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:resman_mobile_customer/src/models/billModel.dart';
import 'package:resman_mobile_customer/src/models/cartDishModel.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphClient.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphQuery.dart';

class BillProvider {
  static String apiUrl = 'https://restaurant-management-server.herokuapp.com';
  Client client = Client();

  Future<List<BillModel>> getAll(String token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    var day = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final response =
        await client.get('$apiUrl/api/bills?day=$day', headers: headers);
    if (response.statusCode == 200) {
      List<BillModel> result = [];
      List<dynamic> list = jsonDecode(response.body);
      for (int i = 0; i < list.length; i++) {
        var billModel = BillModel.fromJson(list[i]);
        result.add(billModel);
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
      throw ('Có lỗi xảy ra khi tải danh sách hoá đơn.');
    }
  }

  Future<List<BillModel>> getAllUserBills(String token, String username) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response =
        await client.get('$apiUrl/api/bills/user/$username', headers: headers);
    if (response.statusCode == 200) {
      List<BillModel> result = [];
      List<dynamic> list = jsonDecode(response.body);
      for (int i = 0; i < list.length; i++) {
        var billModel = BillModel.fromJson(list[i]);
        result.add(billModel);
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
      throw ('Có lỗi xảy ra khi tải danh sách hoá đơn.');
    }
  }

  Future<BillModel> createBill(String token, int addressId,
      List<CartDishModel> cartDishModels, int storeId,
      {String discountCode, String note, String voucherCode}) async {
    final data = await (GraphClient()
          ..authorization(token)
          ..addBody(GraphQuery.createDeliveryBill(
            addressId,
            cartDishModels,
            storeId,
            discountCode: discountCode,
            note: note,
            voucherCode: voucherCode,
          )))
        .connect();

    return BillModel.fromJson(jsonDecode(data['createDeliveryBill']));
  }

  Future<BillModel> getBill(String token, int billId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response =
        await client.post('$apiUrl/api/bills/$billId', headers: headers);
    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Có lỗi xảy ra khi tải hoá đơn.');
    }
  }

  Future<BillModel> updatePaidBillStatus(String token, int billId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response =
        await client.put('$apiUrl/api/bills/$billId/paid', headers: headers);
    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Có lỗi xảy ra khi cập nhật thanh toán hoá đơn.');
    }
  }

  Future<BillModel> updatePreparingBillStatus(String token, int billId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response = await client.put('$apiUrl/api/bills/$billId/preparing',
        headers: headers);
    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Có lỗi xảy ra khi cập nhật đang chuẩn bị hoá đơn.');
    }
  }

  Future<BillModel> updatePrepareDoneBillStatus(
      String token, int billId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response = await client.put('$apiUrl/api/bills/$billId/prepare-done',
        headers: headers);
    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Có lỗi xảy ra khi cập nhật đã chuẩn bị xong hoá đơn.');
    }
  }

  Future<BillModel> updateDeliveringBillStatus(String token, int billId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response = await client.put('$apiUrl/api/bills/$billId/delivering',
        headers: headers);
    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Có lỗi xảy ra khi cập nhật đang giao hoá đơn.');
    }
  }

  Future<BillModel> updateShippingBillStatus(String token, int billId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response = await client.put('$apiUrl/api/bills/$billId/shipping',
        headers: headers);
    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Có lỗi xảy ra khi cập nhật đang ship hoá đơn.');
    }
  }

  Future<BillModel> updateCompleteBillStatus(String token, int billId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response = await client.put('$apiUrl/api/bills/$billId/complete',
        headers: headers);
    if (response.statusCode == 200) {
      return BillModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Có lỗi xảy ra khi cập nhật hoàn thành hoá đơn.');
    }
  }
}

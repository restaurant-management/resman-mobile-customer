import 'package:equatable/equatable.dart';

import '../models/billDetailModel.dart';

class BillModel extends Equatable {
  int id;
  DateTime createAt;
  DateTime prepareAt;
  DateTime preparedAt;
  DateTime shipAt;
  DateTime collectAt;
  double collectValue;
  String voucherCode;
  double voucherValue;
  bool voucherIsPercent;
  String discountCode;
  double discountValue;
  String address;
  double longitude;
  double latitude;
  double rating;
  String note;
  List<BillDetailModel> dishes;

  BillModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    createAt = DateTime.tryParse(json['createAt'].toString());
    prepareAt = DateTime.tryParse(json['prepareAt'].toString());
    preparedAt = DateTime.tryParse(json['preparedAt'].toString());
    shipAt = DateTime.tryParse(json['shipAt'].toString());
    collectAt = DateTime.tryParse(json['collectAt'].toString());
    collectValue = double.tryParse(json['collectValue'].toString());
    voucherCode = json['voucherCode'];
    voucherValue = double.tryParse(json['voucherValue'].toString());
    voucherIsPercent = json['voucherIsPercent'] == 1 ? true : false;
    discountCode = json['discountCode'];
    discountValue = double.tryParse(json['discountValue'].toString());
    address = json['address'];
    longitude = double.tryParse(json['longitude'].toString());
    latitude = double.tryParse(json['latitude'].toString());
    rating = double.tryParse(json['rating'].toString());
    note = json['note'] ?? '';
    List<dynamic> jsonDishes = json['dishes'];
    dishes = [];
    for (int i = 0; i < jsonDishes.length; i++) {
      dishes.add(BillDetailModel.fromJson(jsonDishes[i]));
    }
  }

  double get rawPrice {
    double sum = 0;
    for (int i = 0; i < dishes.length; i++) {
      sum += dishes[i].quantity * dishes[i].price;
    }
    return sum;
  }

  double get realPrice {
    // Calculate voucher discount price
    double voucherPrice = voucherValue != null
        ? voucherIsPercent ? (rawPrice * voucherValue / 100) : voucherValue
        : 0.0;

    // Calculate discount code price
    double discountPrice =
        discountValue != null ? discountValue * rawPrice / 100 : 0.0;

    double realPrice = rawPrice - voucherPrice - discountPrice;
    return realPrice >= 0.0 ? realPrice : 0.0;
  }
}

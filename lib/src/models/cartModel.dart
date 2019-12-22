import 'dart:convert';

import 'cartDishModel.dart';

class CartModel {
  List<CartDishModel> listDishes = [];
  String note;
  String voucherCode;
  String discountCode;
  int addressId;

  CartModel.fromJson(Map<String, dynamic> json) {
    listDishes = (json['listDishes'] as List<dynamic>)
        .map((e) => CartDishModel.fromJson(e))
        .toList();
    note = json['note'] ?? '';
  }

  CartModel.empty() {
    listDishes = [];
    note = '';
    voucherCode = '';
    discountCode = '';
    addressId = null;
  }

  // Note: Don't save code and address because of checking valid.
  Map<String, dynamic> toJson() => {
        'listDishes': listDishes.map((e) => e.toJson()).toList(),
        'note': note
      };
}

import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/models/discountCode.dart';
import 'package:resman_mobile_customer/src/models/voucherCode.dart';

import 'cartDishModel.dart';

class CartModel {
  List<CartDishModel> listDishes = [];
  String note;
  VoucherCode voucherCode;
  DiscountCode discountCode;
  Address address;

  double get rawPrice {
    double sum = 0;
    for (int i = 0; i < listDishes.length; i++) {
      sum += listDishes[i].quantity * listDishes[i].price;
    }
    return sum;
  }

  double get realPrice {
    // Calculate voucher discount price
    double voucherPrice = voucherCode != null
        ? voucherCode.isPercent
            ? (rawPrice * voucherCode.value / 100)
            : voucherCode.value
        : 0.0;
    if (voucherCode != null &&
        voucherCode.maxPriceDiscount != null &&
        voucherPrice > voucherCode.maxPriceDiscount &&
        voucherCode.isPercent) {
      voucherPrice = voucherCode.maxPriceDiscount + .0;
    }

    // Calculate discount code price
    double discountPrice =
        discountCode != null ? discountCode.discount * rawPrice / 100 : 0.0;
    if (discountCode != null &&
        discountCode.maxPriceDiscount != null &&
        discountPrice > discountCode.maxPriceDiscount) {
      discountPrice = discountCode.maxPriceDiscount + .0;
    }

    double realPrice = rawPrice - voucherPrice - discountPrice;
    return realPrice >= 0.0 ? realPrice : 0.0;
  }

  CartModel.fromJson(Map<String, dynamic> json) {
    listDishes = (json['listDishes'] as List<dynamic>)
        .map((e) => CartDishModel.fromJson(e))
        .toList();
    note = json['note'] ?? '';
  }

  CartModel.empty() {
    listDishes = [];
    note = '';
    voucherCode = null;
    discountCode = null;
    address = null;
  }

  // Note: Don't save code and address because of checking valid.
  Map<String, dynamic> toJson() =>
      {'listDishes': listDishes.map((e) => e.toJson()).toList(), 'note': note};
}

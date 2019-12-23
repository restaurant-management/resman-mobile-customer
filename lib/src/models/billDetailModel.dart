import 'package:equatable/equatable.dart';
import 'package:resman_mobile_customer/src/models/dishModal.dart';

class BillDetailModel extends Equatable {
  int quantity;
  double price;
  DishModal dish;

  BillDetailModel.fromJson(Map<String, dynamic> parsedJson) {
    quantity = parsedJson['quantity'];
    price = parsedJson['price'] + .0;
    dish = DishModal.fromJson(parsedJson['dish']);
  }
}

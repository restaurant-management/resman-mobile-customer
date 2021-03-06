import 'package:equatable/equatable.dart';
import 'package:resman_mobile_customer/src/models/cartDishModel.dart';

abstract class CartItemEvent extends Equatable {
  CartItemEvent([List props = const []]) : super(props);
}

class FetchCartItemDetail extends CartItemEvent {
  final CartDishModel cartDish;

  FetchCartItemDetail(this.cartDish) : super([cartDish]);

  @override
  String toString() => 'FetchCartItemDetail (dishId: ${cartDish.dishId})';
}
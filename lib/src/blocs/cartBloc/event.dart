import 'package:equatable/equatable.dart';
import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/models/cartModel.dart';
import 'package:resman_mobile_customer/src/models/dailyDish.dart';
import 'package:resman_mobile_customer/src/models/discountCode.dart';
import 'package:resman_mobile_customer/src/models/voucherCode.dart';

abstract class CartBlocEvent extends Equatable {
  CartBlocEvent([List props = const []]) : super(props);
}

class FetchCartBloc extends CartBlocEvent {
  @override
  String toString() => 'FetchCartBloc';
}

class SaveCartBloc extends CartBlocEvent {
  @override
  String toString() => 'SaveCartBloc';
}

class AddDishIntoCart extends CartBlocEvent {
  final DailyDish dish;

  AddDishIntoCart(this.dish) : super([dish]);

  @override
  String toString() => 'AddDishIntoCart {id: ${dish.dish.dishId}';
}

class RemoveDishFromCart extends CartBlocEvent {
  final int dishId;

  RemoveDishFromCart(this.dishId) : super([dishId]);

  @override
  String toString() => 'RemoveDishFromCart (dishId: $dishId})';
}

class ChangeDistQuantityInCart extends CartBlocEvent {
  final int dishId;
  final int quantity;

  ChangeDistQuantityInCart(this.dishId, this.quantity)
      : super([dishId, quantity]);

  @override
  String toString() =>
      'ChangeDistQuantityInCart (dishId: $dishId, quantity: $quantity)';
}

class ChangeVoucherInCart extends CartBlocEvent {
  final VoucherCode voucherCode;

  ChangeVoucherInCart(this.voucherCode)
      : super([voucherCode]);

  @override
  String toString() =>
      'ChangeVoucherInCart (code: ${voucherCode.code})';
}

class ChangeDiscountInCart extends CartBlocEvent {
  final DiscountCode discountCode;

  ChangeDiscountInCart(this.discountCode)
      : super([discountCode]);

  @override
  String toString() =>
      'ChangeDiscountInCart (code: ${discountCode.code})';
}

class ChangeAddressInCart extends CartBlocEvent {
  final Address address;

  ChangeAddressInCart(this.address)
      : super([address]);

  @override
  String toString() =>
      'ChangeAddressInCart (address: ${address.address})';
}

class CreateBillFromCart extends CartBlocEvent {
  @override
  String toString() => 'CreateBillFromCart';
}

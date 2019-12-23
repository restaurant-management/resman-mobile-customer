import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/event.dart';
import 'package:resman_mobile_customer/src/widgets/bottomSheet/addressBottomSheet.dart';

showAddressBottomSheet(BuildContext context) {
  CartBloc cartBloc = CartBloc();

  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    context: context,
    builder: (context) {
      return AddressBottomSheet(
          selectedAddress: cartBloc.currentCart.address,
          onSelect: (address) {
            cartBloc.dispatch(ChangeAddressInCart(address));
          });
    },
  );
}

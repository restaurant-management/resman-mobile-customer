import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/event.dart';
import 'package:resman_mobile_customer/src/widgets/bottomSheet/voucherBottomSheet.dart';

showVoucherBottomSheet(BuildContext context) {
  CartBloc cartBloc = CartBloc();

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      context: context,
      builder: (context) {
        return BlocBuilder(
          bloc: cartBloc,
          builder: (context, state) {
            return VoucherBottomSheet(
              selectedVoucher: cartBloc.currentCart.voucherCode,
              onSelectVoucher: (voucher) {
                cartBloc.dispatch(ChangeVoucherInCart(voucher));
              },
            );
          },
        );
      });
}

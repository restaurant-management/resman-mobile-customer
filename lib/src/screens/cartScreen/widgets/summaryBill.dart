import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/state.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

class SummaryBill extends StatelessWidget {
  final CartBloc _cartBloc = CartBloc();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final onBackground = Theme.of(context).colorScheme.onSurface;
    return Card(
      margin: EdgeInsets.all(0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Tổng tiền: ',
              textAlign: TextAlign.left,
              style: TextStyles.h4Bold.merge(TextStyle(color: primaryColor)),
            ),
            BlocBuilder(
              bloc: _cartBloc,
              builder: (BuildContext context, state) {
                if (state is CartBlocSaved || state is CartBlocFetched) {
                  var listDishes = _cartBloc.currentCart.listDishes;
                  int sum = 0;
                  for (int i = 0; i < listDishes.length; i++) {
                    sum += listDishes[i].quantity * listDishes[i].price;
                  }
                  return Text(
                    '$sum VNĐ',
                    style:
                        TextStyles.h4Bold.merge(TextStyle(color: onBackground)),
                  );
                }
                return Text(
                  'Đang tải...',
                  style:
                      TextStyles.h4Bold.merge(TextStyle(color: onBackground)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

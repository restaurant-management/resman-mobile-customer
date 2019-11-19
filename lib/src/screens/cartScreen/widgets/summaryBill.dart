import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/state.dart';

class SummaryBill extends StatelessWidget {
  final CartBloc _cartBloc = CartBloc();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: EdgeInsets.all(0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Tổng tiền',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
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
                      return Text('$sum VNĐ');
                    }
                    return Text('Đang tải...');
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
              width: 1,
              child: Container(
                color: primaryColor,
              ),
            ),
            InkWell(
              splashColor: primaryColor,
              onTap: () {},
              child: Text(
                'Mã giảm giá?',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}

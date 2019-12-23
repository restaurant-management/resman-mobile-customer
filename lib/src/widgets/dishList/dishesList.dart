import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/dailyDishBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/dailyDishBloc/state.dart';
import 'package:resman_mobile_customer/src/models/dailyDish.dart';
import 'package:resman_mobile_customer/src/models/dishModal.dart';

import 'dishItemCard.dart';

class DishesList extends StatefulWidget {
  final List<DishModal> listDish;

  const DishesList({Key key, @required this.listDish})
      : assert(listDish != null),
        super(key: key);

  @override
  _DishesListState createState() => _DishesListState();
}

class _DishesListState extends State<DishesList> {
  List<DishModal> get listDish => widget.listDish;

  final DailyDishBloc dailyDishBloc = DailyDishBloc();

  List<DailyDish> dailyDishes = [];

  @override
  void initState() {
    super.initState();
    dailyDishes = dailyDishBloc.listDailyDish;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: BlocListener(
            bloc: dailyDishBloc,
            listener: (context, state) {
              if (state is DailyDishFetched) {
                setState(() {
                  dailyDishes = state.listDailyDish;
                });
              }
            },
            child: Column(
              children: _buildRow(listDish),
            ),
          ),
        ));
  }

  List<Widget> _buildRow(List<DishModal> listDish) {
    List<Widget> rows = [];
    for (int i = 0; i < listDish.length; i += 2) {
      rows.add(SizedBox(
        height: 10,
      ));
      rows.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: DishItemCard(
                dish: listDish[i],
                dailyDish: dailyDishes.firstWhere(
                    (e) => listDish[i].dishId == e.dish.dishId,
                    orElse: () => null),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: i + 1 < listDish.length
                  ? DishItemCard(
                      dish: listDish[i + 1],
                      dailyDish: dailyDishes.firstWhere(
                          (e) => listDish[i + 1].dishId == e.dish.dishId,
                          orElse: () => null),
                    )
                  : Container(),
            ),
          ],
        ),
      ));
    }
    rows.add(SizedBox(
      height: 60,
    ));
    return rows;
  }
}

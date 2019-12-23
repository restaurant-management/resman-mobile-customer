import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/models/dailyDish.dart';
import 'package:resman_mobile_customer/src/widgets/dishList/todayDishItemCard.dart';

class TodayDishesList extends StatefulWidget {
  final List<DailyDish> listDailyDish;

  const TodayDishesList({Key key, @required this.listDailyDish})
      : assert(listDailyDish != null),
        super(key: key);

  @override
  _TodayDishesListState createState() => _TodayDishesListState();
}

class _TodayDishesListState extends State<TodayDishesList> {
  List<DailyDish> get listDailyDish => widget.listDailyDish;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: _buildRow(listDailyDish),
        ),
      ),
    );
  }

  List<Widget> _buildRow(List<DailyDish> listDailyDish) {
    List<Widget> rows = [];
    for (int i = 0; i < listDailyDish.length; i += 2) {
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
              child: TodayDishItemCard(
                dailyDish: listDailyDish[i],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: i + 1 < listDailyDish.length
                  ? TodayDishItemCard(
                      dailyDish: listDailyDish[i + 1],
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

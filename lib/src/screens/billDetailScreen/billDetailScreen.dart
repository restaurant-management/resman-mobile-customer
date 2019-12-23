import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resman_mobile_customer/src/models/billModel.dart';
import 'package:resman_mobile_customer/src/widgets/AppBars/backAppBar.dart';

import 'widgets/dishList.dart';
import 'widgets/summaryBill.dart';

class BillDetailScreen extends StatefulWidget {
  final BillModel bill;

  const BillDetailScreen({Key key, @required this.bill})
      : assert(bill != null),
        super(key: key);

  @override
  _BillDetailScreenState createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  BillModel get bill => widget.bill;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: 'Chi tiết hóa đơn',
        showShoppingCart: false,
      ),
      bottomNavigationBar: SizedBox(
          height: 56,
          child: SummaryBill(
            bill: bill,
          )),
      body: SafeArea(
        child: Stack(children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.background,
            child: DishList(
              headerHeight: 10,
              billDetails: bill.dishes,
            ),
          ),
        ]),
      ),
    );
  }
}

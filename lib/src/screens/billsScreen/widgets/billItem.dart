import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:resman_mobile_customer/src/models/billModel.dart';
import 'package:resman_mobile_customer/src/screens/billDetailScreen/billDetailScreen.dart';

class BillItem extends StatefulWidget {
  final BillModel bill;

  const BillItem({Key key, @required this.bill})
      : assert(bill != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => BillItemState();
}

class BillItemState extends State<BillItem> {
  BillModel get bill => widget.bill;

  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BillDetailScreen(
                      bill: bill,
                    )));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: IntrinsicWidth(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(0),
                      color: Theme.of(context).primaryColor.withAlpha(220),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'Mã: ${bill.id}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(0),
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          _mapBillStatus(bill),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Số món',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(bill.dishes.length.toString())
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 1,
                      child: Container(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Thời gian',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(DateFormat('hh:mm dd/MM/yyyy')
                              .format(bill.createAt.toLocal()))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWidget(String text,
      {VoidCallback onPressed, double increaseWidthBy = 60}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GradientButton(
          child: Text(text),
          increaseWidthBy: increaseWidthBy,
          callback: onPressed,
          gradient: LinearGradient(
            colors: <Color>[
              !isUpdating
                  ? Color.fromRGBO(88, 150, 176, 1)
                  : Color.fromRGBO(0, 0, 0, 0.3),
              !isUpdating
                  ? Color.fromRGBO(88, 39, 176, 1)
                  : Color.fromRGBO(0, 0, 0, 0.3),
            ],
            stops: [0.1, 1.0],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ],
    );
  }

  String _mapBillStatus(BillModel bill) {
    if (bill.collectAt != null) {
      return 'Đã thanh toán';
    } else if (bill.shipAt != null)
      return 'Đang giao';
    else if (bill.preparedAt != null)
      return 'Chuẩn bị xong';
    else if (bill.prepareAt != null) return 'Đang chuẩn bị';

    return 'Đã nhận hóa đơn';
  }
}

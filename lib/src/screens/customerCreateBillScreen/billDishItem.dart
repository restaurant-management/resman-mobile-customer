import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/FakeBillItem.dart';

class BillDishItem extends StatefulWidget {
  final DishItem dishItem;

  const BillDishItem({Key key, this.dishItem}) : super(key: key);


  @override
  _BillDishItemState createState() => _BillDishItemState();
}

class _BillDishItemState extends State<BillDishItem> {
  int _count;

  @override
  void initState() {
    _count = widget.dishItem.quantity;
    super.initState();
  }
  void _increase() {
    setState(() {
      _count = _count + 1;
    });
  }

  void _decrease() {
    setState(() {
      _count = _count == 1 ? _count : _count - 1;
    });
  }
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      color: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
    ),
      child: Container(
        height: 70,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
              child: CachedNetworkImage(
                placeholder: (BuildContext context, String url) => Image.asset(
                    'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4'),
                imageUrl: widget.dishItem.image,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.dishItem.name,
                      style: TextStyle(
                        color: colorScheme.onBackground,
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${widget.dishItem.price.toString()} VNĐ',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    width: 60,
                    child: FlatButton(
                      color: Colors.white,
                      splashColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: colorScheme.onBackground,
                      ),
                      onPressed: _increase,
                    ),
                  ),
                  SizedBox(
                      height: 20,
                      child: Row(
                        children: <Widget>[
                          Text(_count.toString()),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                    width: 60,
                    child: FlatButton(
                      color: Colors.white,
                      splashColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: colorScheme.onBackground,
                      ),
                      onPressed: _decrease,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

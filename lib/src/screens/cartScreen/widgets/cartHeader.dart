import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CartHeader extends StatelessWidget {
  final double height;
  final String title;

  const CartHeader({Key key, @required this.height, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: <Color>[
              Theme.of(context).primaryColor.withAlpha(220),
              Theme.of(context).primaryColor.withAlpha(120),
              Theme.of(context).primaryColor.withAlpha(0),
            ],
            stops: [0.1, 0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title == null ? 'Danh sách món đã chọn' : title,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
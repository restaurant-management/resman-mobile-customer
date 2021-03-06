import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/state.dart';
import 'package:resman_mobile_customer/src/utils/gradientColor.dart';

class SecondaryCartButton extends StatefulWidget {
  final Color color;

  const SecondaryCartButton({Key key, this.color}) : super(key: key);

  @override
  _SecondaryCartButtonState createState() => _SecondaryCartButtonState();
}

class _SecondaryCartButtonState extends State<SecondaryCartButton>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  bool _newValue = false;

  final CartBloc _cartBloc = CartBloc();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onPress() {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cartBloc,
      listener: (BuildContext context, state) {
        if (state is CartBlocSaved ||
            state is CartBlocFetched ||
            state is CartBlocCreatedBill) {
          setState(() {
            _count = _cartBloc.currentCart.listDishes.length;
            _newValue = true;
            Future.delayed(Duration(milliseconds: 1500)).then((_) {
              setState(() {
                _newValue = false;
              });
            });
          });
        }
      },
      child: InkWell(
        onTap: _onPress,
        child: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: GradientColor.of(context).primaryGradient,
              borderRadius: BorderRadius.circular(90),
            ),
            child: FloatingActionButton(
              elevation: 10,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.shopping_cart,
                color: widget.color != null ? widget.color : Colors.white,
              ),
              onPressed: _onPress,
            ),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Icon(
                  Icons.brightness_1,
                  color: Colors.red,
                  size: 20,
                ),
                Text(
                  _count.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

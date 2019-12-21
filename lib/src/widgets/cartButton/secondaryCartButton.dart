import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animation_set/animation_set.dart';
import 'package:flutter_animation_set/animator.dart';
import 'package:flutter_animation_set/widget/behavior_animations.dart';
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

  Widget makeLove(double tx, double ty, Curve curves) {
    return Container(
      width: 10,
      height: 10,
      child: AnimatorSet(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        animatorSet: [
          Serial(
            duration: 800,
            serialList: [
              TX(from: 0.0, to: tx, curve: curves),
              TY(from: 0.0, to: ty, curve: curves),
              SX(from: 1.0, to: 0.2, curve: curves),
              SY(from: 1.0, to: 0.2, curve: curves),
              O(from: 1.0, to: 0.8, curve: curves)
            ],
          ),
        ],
      ),
    );
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
      child: AnimatorSet(
        animationType: AnimationType.once,
        animatorSet: [
          ..._newValue
              ? [
                  Serial(duration: 2000, serialList: [
                    SX(from: 0.5, to: 1.0, curve: Curves.bounceInOut),
                    SY(from: 0.5, to: 1.0, curve: Curves.bounceInOut),
                  ]),
                ]
              : []
        ],
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
                  ...(_newValue
                      ? [
                          makeLove(10, 20, Curves.fastOutSlowIn),
                          makeLove(-10, 20, Curves.fastOutSlowIn),
                          makeLove(20, 0, Curves.fastOutSlowIn),
                          makeLove(-20, 0, Curves.fastOutSlowIn),
                          makeLove(-10, -20, Curves.fastOutSlowIn),
                          makeLove(10, -20, Curves.fastOutSlowIn),
                        ]
                      : []),
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
      ),
    );
  }
}

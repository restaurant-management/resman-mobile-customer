import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';
import 'package:resman_mobile_customer/src/screens/dishesTodayScreen/dishesTodayScreen.dart';
import 'package:resman_mobile_customer/src/screens/storeSelectionScreen/storeSelectionScreen.dart';

import '../../blocs/authenticationBloc/bloc.dart';
import '../../blocs/authenticationBloc/event.dart';
import '../../widgets/animationLogo.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationBloc authenticationBloc;

  bool _showLoading = false;

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc();
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [
            colorScheme.primaryVariant,
            colorScheme.primary,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 90.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'HeroLogoImage',
            child: AnimationLogo(
              animationTime: 1000,
              onAnimationCompleted: () async {
                setState(() {
                  _showLoading = true;
                });
                if ((await Repository().getStore()) != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => DishesTodayScreen(),
                    ),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => StoreSelectionScreen(),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 5,
            width: 100,
            child: _showLoading
                ? LinearProgressIndicator(
                    backgroundColor: colorScheme.onPrimary,
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

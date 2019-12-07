import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resman_mobile_customer/src/screens/dishesTodayScreen/dishesTodayScreen.dart';
import 'package:resman_mobile_customer/src/screens/storeSelectionScreen/storeSelectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc();
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [
            Color(0xFFFC5C7D),
            Color(0xFF6A82FB),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 90.0),
      child: Hero(
        tag: 'HeroLogoImage',
        child: AnimationLogo(
          animationTime: 1000,
          onAnimationCompleted: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if(prefs.containsKey('store')) {
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
    );
  }
}

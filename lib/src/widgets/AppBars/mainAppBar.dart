import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resman_mobile_customer/src/utils/gradientColor.dart';

import '../../screens/searchScreen/searchScreen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  MainAppBar({Key key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: GradientColor.of(context).primaryGradient,
        ),
      ),
      elevation: 5,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: colorScheme.onPrimary,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Hero(
        tag: 'HeroLogoImage',
        child: Text(
          'Resman',
          style:
              TextStyle(color: colorScheme.onPrimary, fontSize: 40, fontFamily: 'Rukola'),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
        )
      ],
    );
  }
}

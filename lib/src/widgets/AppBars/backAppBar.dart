import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resman_mobile_customer/src/utils/gradientColor.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

import '../cartButton/primaryCartButton.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showShoppingCart;
  final List<Widget> right;
  final PreferredSizeWidget bottom;
  final bool showBackButton;
  final String title;

  BackAppBar(
      {Key key,
      this.showShoppingCart = true,
      this.right,
      this.bottom,
      this.showBackButton = true,
      this.title})
      : preferredSize = Size.fromHeight(
            56.0 + (bottom != null ? bottom.preferredSize.height : 0)),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (showShoppingCart) actions.add(PrimaryCartButton());
    if (right != null)
      actions.addAll(right);
    else
      actions.add(Container());

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: GradientColor.of(context).primaryGradient,
        ),
      ),
      elevation: 4,
      centerTitle: true,
      bottom: bottom,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : Container(),
      title: title == null
          ? Text(
              'Resman',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 40,
                  fontFamily: 'Rukola'),
            )
          : Text(
              title,
              style: TextStyles.h4.merge(
                TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            ),
      actions: actions,
    );
  }
}

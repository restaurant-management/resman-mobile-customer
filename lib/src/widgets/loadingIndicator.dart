import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

class LoadingIndicator extends StatelessWidget {
  final String message;
  final Color messageColor;

  const LoadingIndicator({Key key, this.message, this.messageColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildRandom(context),
            SizedBox(height: 10),
            message != null ? Text(
              message,
              style: TextStyles.h4.merge(TextStyle(color: messageColor)),
            ) : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildRandom(BuildContext context) {
    int _random = Random().nextInt(3);
    switch (_random) {
      case 0:
        return _buildCircularProgress();
      case 1:
        return _buildLoadingGif(context);
      case 2:
        return _buildLoadingGif2(context);
      default:
        return _buildCircularProgress();
    }
  }

  Widget _buildCircularProgress() {
    return CircularProgressIndicator();
  }

  Widget _buildLoadingGif(BuildContext context) {
    return Image.asset(
      'assets/icons/loading.gif',
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width * 0.2,
    );
  }

  Widget _buildLoadingGif2(BuildContext context) {
    return Image.asset(
      'assets/icons/loading2.gif',
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width * 0.3,
    );
  }
}

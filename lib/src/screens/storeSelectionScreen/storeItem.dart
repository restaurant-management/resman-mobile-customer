import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resman_mobile_customer/src/constants/textStyles.dart';
import 'package:resman_mobile_customer/src/screens/dishesTodayScreen/dishesTodayScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storeSelectionScreen.dart';

class StoreItem extends StatelessWidget {
  final Store store;

  const StoreItem({Key key, @required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('store', store.id);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => DishesTodayScreen(),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 8),
        color: colorScheme.onPrimary,
        child: Padding(
          padding:
          const EdgeInsets.only(left: 30, right: 12, top: 20, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  ..._buildLeftIcon(
                    colorScheme,
                    Icon(
                      Icons.fastfood,
                      size: 20,
                      color: colorScheme.onBackground,
                    ),
                    '2',
                  ),
                  ..._buildLeftIcon(
                    colorScheme,
                    Icon(
                      Icons.star,
                      size: 20,
                      color: colorScheme.onBackground,
                    ),
                    store.rating.toString(),
                  ),
                  ..._buildLeftIcon(
                    colorScheme,
                    Icon(
                      Icons.alarm,
                      size: 20,
                      color: colorScheme.onBackground,
                    ),
                    DateFormat('hh:mm').format(store.openTime) +
                        '\n' + '|' +'\n' +
                        DateFormat('hh:mm').format(store.closeTime),
                  )
                ],
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 210,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          placeholder: (BuildContext context, String url) =>
                              Image.asset('assets/images/default-avatar.jpg'),
                          imageUrl: store.logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Text(
                          store.name,
                          style: TextStyles.h4Headline.merge(
                            TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.pin_drop,
                          color: colorScheme.onBackground,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          store.address,
                          style: TextStyles.subTitle3
                              .merge(TextStyle(color: colorScheme.onBackground)),
                        ),
                        SizedBox(width: 14),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLeftIcon(
      ColorScheme colorScheme, Widget icon, String bottomText) {
    return [
      Stack(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: Column(
            children: <Widget>[
              Container(
                child: icon,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    border: new Border.all(
                        color: colorScheme.onBackground, width: 1)),
                width: 40,
                height: 40,
              ),
              SizedBox(height: 4),
              Text(
                bottomText,
                textAlign: TextAlign.center,
                style: TextStyles.link2
                    .merge(TextStyle(color: colorScheme.onBackground,)),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ])
    ];
  }
}
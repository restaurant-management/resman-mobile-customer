import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:intl/intl.dart';
import 'package:resman_mobile_customer/src/fakeReviewComments.dart';
import 'package:resman_mobile_customer/src/screens/dishDetailScreen/reviewComment.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

import '../../models/dailyDish.dart';
import '../../models/dishModal.dart';
import '../../widgets/AppBars/backAppBar.dart';
import '../../widgets/drawerScaffold.dart';
import 'widgets/addCartButton.dart';
import 'widgets/expanedDetail.dart';

class DishDetailScreen extends StatefulWidget {
  final DishModal dishModal;
  final DailyDish dailyDish;

  const DishDetailScreen({Key key, this.dishModal, this.dailyDish})
      : assert((dishModal == null || dailyDish == null) &&
            (dishModal != null || dailyDish != null)),
        super(key: key);

  @override
  _DishDetailScreenState createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  List<ReviewCommentModal> reviewComments;
  int _discountPrice;
  DishModal _dish;
  bool liked;
  String _value;
  List<String> comments;

  @override
  void initState() {
    _value = null;
    comments = [];
    reviewComments = FakeReviewComments.reviewComments;
    if (widget.dailyDish != null) {
      _dish = widget.dailyDish.dish;
      _discountPrice = widget.dailyDish.price;
    } else {
      _dish = widget.dishModal;
      _discountPrice = 0;
    }
    liked = false;
    super.initState();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return DrawerScaffold(
      appBar: BackAppBar(),
      bottomNavigationBar: widget.dailyDish != null
          ? AddCartButton(
              dailyDish: widget.dailyDish,
            )
          : Container(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ImagesSlider(
              items: map<Widget>(_dish.images, (index, i) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(i), fit: BoxFit.cover)),
                );
              }),
              autoPlay: true,
              viewportFraction: 1.0,
              aspectRatio: 1.5,
              distortion: false,
              align: IndicatorAlign.bottom,
              indicatorWidth: 5,
              indicatorColor: Theme.of(context).colorScheme.background,
              indicatorBackColor: primaryColor,
              updateCallback: (index) {},
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      _dish.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                  IconButton(
                    icon: liked
                        ? Icon(
                            Icons.favorite,
                            color: primaryColor,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                          ),
                    onPressed: () {
                      setState(() {
                        liked = !liked;
                      });
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: <Widget>[
                  _discountPrice > 0
                      ? Text(
                          '${_dish.defaultPrice} VNĐ',
                          style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        )
                      : Container(),
                  _discountPrice > 0
                      ? SizedBox(
                          width: 20,
                        )
                      : Container(),
                  Text(
                    '${_discountPrice > 0 ? _discountPrice : _dish.defaultPrice} VNĐ',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            ExpandedDetail(
              title: 'Chi tiết',
              child: Text(
                _dish.description,
                style: TextStyle(color: Colors.black),
              ),
              expand: true,
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            ExpandedDetail(
              title: 'Nhận xét',
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4'),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            _showReviewCommentBottomSheet(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            width: 300,
                            child: Text(
                              'Nhận xét...',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 600,
                    child: _buildListReviewComment(),
                  ),
                ],
              ),
              expand: true,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _showReviewCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          var colorScheme = Theme.of(context).colorScheme;
          return Wrap(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 150),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      print(value.split('\n').length);
                      if(value.split('\n').length >10)
                        setState(() {

                        });
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    style: TextStyles.h3
                        .merge(TextStyle(color: colorScheme.onBackground)),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            comments.add(_value);
                            Navigator.pop(context);
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Thêm thành công')));
                          });
                        },
                        icon: Icon(
                          Icons.send,
                          color: colorScheme.primary,
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                'https://avatars1.githubusercontent.com/u/36977998?s=460&v=4'),
                          ),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: "Nhận xét...",
                      hintStyle: TextStyles.h3.merge(TextStyle(
                        color: colorScheme.onSurface,
                      )),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildListReviewComment() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: reviewComments.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0)
          return Column(
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              ReviewComment(
                reviewComment: reviewComments[index],
              ),
            ],
          );
        return ReviewComment(
          reviewComment: reviewComments[index],
        );
      },
    );
  }
}

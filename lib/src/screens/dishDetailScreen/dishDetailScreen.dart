import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:like_button/like_button.dart';
import 'package:resman_mobile_customer/src/blocs/commentBloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/state.dart';
import 'package:resman_mobile_customer/src/blocs/favouriteBloc.dart';
import 'package:resman_mobile_customer/src/models/comment.dart';
import 'package:resman_mobile_customer/src/models/userModel.dart';
import 'package:resman_mobile_customer/src/screens/dishDetailScreen/reviewComment.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:resman_mobile_customer/src/widgets/errorIndicator.dart';
import 'package:resman_mobile_customer/src/widgets/loadingIndicator.dart';
import 'package:toast/toast.dart';

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
  int _discountPrice;
  DishModal _dish;
  UserModel _currentUser;
  bool liked;
  List<String> comments;
  TextEditingController _commentController = TextEditingController();

  CommentBloc _commentBloc;
  FavouriteBloc _favouriteBloc;

  final CurrentUserBloc _currentUserBloc = CurrentUserBloc();

  @override
  void initState() {
    comments = [];
    if (widget.dailyDish != null) {
      _dish = widget.dailyDish.dish;
      _discountPrice = widget.dailyDish.dish.price;
    } else {
      _dish = widget.dishModal;
      _discountPrice = 0;
    }
    liked = false;
    _commentBloc = CommentBloc(_dish.dishId);
    _favouriteBloc = FavouriteBloc();
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
  void dispose() {
    _commentBloc.dispose();
    _favouriteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return BlocListener(
      bloc: _currentUserBloc,
      listener: (context, state) {
        if (state is CurrentUserProfileFetchFailure) {
          _currentUserBloc.dispatch(FetchCurrentUserProfile());
        } else if (state is CurrentUserProfileFetched) {
          setState(() {
            _currentUser = state.user;
          });
        }
      },
      child: DrawerScaffold(
        appBar: BackAppBar(),
        bottomNavigationBar: widget.dailyDish != null
            ? AddCartButton(
                dailyDish: widget.dailyDish,
              )
            : Container(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                    Expanded(
                      child: Text(
                        _dish.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    _buildLikeButton(_currentUser),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    _discountPrice != null &&
                            _discountPrice > 0 &&
                            _discountPrice < _dish.defaultPrice
                        ? Text(
                            '${_dish.defaultPrice} VNĐ',
                            style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          )
                        : Container(),
                    _discountPrice != null &&
                            _discountPrice > 0 &&
                            _discountPrice < _dish.defaultPrice
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _dish.description,
                    style: TextStyle(color: Colors.black),
                  ),
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
                onFirstOpen: () {
                  _commentBloc.dispatch(FetchComment());
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 0.5, color: colorScheme.onSurface),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 50.0,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Image.asset(
                                    'assets/images/default-avatar.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                  imageUrl: _currentUser?.avatar ?? '',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: _currentUser != null
                                  ? () {
                                      _showReviewCommentBottomSheet(
                                          context, _currentUser.avatar);
                                    }
                                  : null,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 50,
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
                    ),
                    BlocBuilder(
                      bloc: _commentBloc,
                      builder: (context, state) {
                        if (state is CommentBlocFetchFailure) {
                          return ErrorIndicator(
                            message: 'Tải bình luận thất bại!',
                            reloadOnPressed: () {
                              _commentBloc.dispatch(FetchComment());
                            },
                          );
                        } else if (state is CommentBlocFetching) {
                          return LoadingIndicator(
                            message: 'Đang tải bình luận...',
                            messageColor: colorScheme.onBackground,
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              ..._buildListReviewComment(_commentBloc.comments)
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
                expand: false,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showReviewCommentBottomSheet(BuildContext context, String avatar) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          var colorScheme = Theme.of(context).colorScheme;
          return BlocBuilder(
            bloc: _commentBloc,
            builder: (context, state) {
              return Wrap(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 150),
                      child: TextField(
                        controller: _commentController,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        autofocus: true,
                        style: TextStyles.h3
                            .merge(TextStyle(color: colorScheme.onBackground)),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: state is CommentBlocCreatingComment
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    _commentBloc.dispatch(
                                        CreateComment(_commentController.text));
                                    _commentBloc.state.listen((state) {
                                      if (state is CommentBlocCreateSuccess) {
                                        Navigator.pop(context);
                                        Toast.show('Đăng nhận xét thành công!',
                                            context);
                                      } else if (state
                                          is CommentBlocCreateFailure) {
                                        Toast.show(
                                            'Có lỗi xảy ra khi đăng nhận xét!',
                                            context,
                                            gravity: Toast.CENTER);
                                      }
                                    });
                                  },
                            icon: state is CommentBlocCreatingComment
                                ? CircularProgressIndicator()
                                : Icon(
                                    Icons.send,
                                    color: colorScheme.primary,
                                  ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/default-avatar.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    fit: BoxFit.cover,
                                    imageUrl: avatar,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
            },
          );
        });
  }

  List<Widget> _buildListReviewComment(List<Comment> comments) {
    return comments
        .asMap()
        .map((index, value) {
          if (index == 0)
            return MapEntry(
                index,
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    ReviewComment(
                      reviewComment: comments[index],
                    ),
                  ],
                ));
          return MapEntry(
              index,
              ReviewComment(
                reviewComment: comments[index],
              ));
        })
        .values
        .toList();
  }

  Widget _buildLikeButton(UserModel user) {
    final colorScheme = Theme.of(context).colorScheme;
    return LikeButton(
      isLiked: user != null
          ? user.favouriteDishes.firstWhere((item) => item == _dish.dishId,
                  orElse: () => -1) >
              -1
          : false,
      countPostion: CountPostion.left,
      countBuilder: (count, isLiked, text) {
        return Text(
          text,
          style:
              TextStyles.h5.merge(TextStyle(color: colorScheme.onBackground)),
        );
      },
      likeBuilder: (isLiked) {
        return Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? colorScheme.primary : colorScheme.onSurface,
        );
      },
      onTap: (isLiked) async {
        _favouriteBloc.dispatch(isLiked
            ? UnFavouriteDish(_dish.dishId)
            : FavouriteDish(_dish.dishId));
        return !isLiked;
      },
    );
  }
}

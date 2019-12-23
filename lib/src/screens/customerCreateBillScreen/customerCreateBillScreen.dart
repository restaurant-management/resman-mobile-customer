import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/authenticationBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/authenticationBloc/state.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/state.dart';
import 'package:resman_mobile_customer/src/blocs/loginBloc/bloc.dart';
import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/models/cartDishModel.dart';
import 'package:resman_mobile_customer/src/models/discountCode.dart';
import 'package:resman_mobile_customer/src/models/voucherCode.dart';
import 'package:resman_mobile_customer/src/screens/billDetailScreen/billDetailScreen.dart';
import 'package:resman_mobile_customer/src/screens/cartScreen/widgets/cartItem.dart';
import 'package:resman_mobile_customer/src/screens/customerCreateBillScreen/widgets/showAddressBottomSheet.dart';
import 'package:resman_mobile_customer/src/screens/customerCreateBillScreen/widgets/showDiscountBottomSheet.dart';
import 'package:resman_mobile_customer/src/screens/customerCreateBillScreen/widgets/showVoucherBottomSheet.dart';
import 'package:resman_mobile_customer/src/screens/dishesTodayScreen/dishesTodayScreen.dart';
import 'package:resman_mobile_customer/src/utils/gradientColor.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:resman_mobile_customer/src/widgets/AppBars/backAppBar.dart';
import 'package:resman_mobile_customer/src/widgets/drawerScaffold.dart';
import 'package:resman_mobile_customer/src/widgets/loginAlert.dart';

class CustomerCreateBillScreen extends StatefulWidget {
  @override
  _CustomerCreateBillScreen createState() => _CustomerCreateBillScreen();
}

class _CustomerCreateBillScreen extends State<CustomerCreateBillScreen> {
  String note;
  List<CartDishModel> dishItems = [];
  Address billAddress;
  VoucherCode voucherCode;
  DiscountCode discountCode;
  double price = 0;
  double discountPrice = 0;
  bool addSuccess = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CartBloc _cartBloc = CartBloc();
  AuthenticationBloc _authenticationBloc = AuthenticationBloc();
  LoginBloc _loginBloc = LoginBloc();

  @override
  void initState() {
    price = _cartBloc.currentCart.rawPrice;
    discountPrice = _cartBloc.currentCart.realPrice;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return DrawerScaffold(
      key: _scaffoldKey,
      appBar: BackAppBar(
        title: 'Tạo hóa đơn',
        showShoppingCart: false,
      ),
      body: BlocListener(
        bloc: _cartBloc,
        listener: (context, state) {
          if (state is CartBlocFetched || state is CartBlocSaved) {
            setState(() {
              note = _cartBloc.currentCart.note;
              dishItems = _cartBloc.currentCart.listDishes;
              voucherCode = _cartBloc.currentCart.voucherCode;
              discountCode = _cartBloc.currentCart.discountCode;
              billAddress = _cartBloc.currentCart.address;
              price = _cartBloc.currentCart.rawPrice;
              discountPrice = _cartBloc.currentCart.realPrice;
            });
          } else if (state is CartBlocCreatedBill) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => BillDetailScreen(bill: state.bill,),
              ),
            );
          } else if (state is CartBlocCreateBillFailure) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Lỗi khi tạo hóa đơn!"),
                  content: new Text(state.error),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text(
                        "Oke",
                        style: TextStyle(
                          color: colorScheme.primary,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                TextField(
                  style: TextStyles.h5
                      .merge(TextStyle(color: colorScheme.onBackground)),
                  scrollPhysics: BouncingScrollPhysics(),
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    filled: true,
                    fillColor: colorScheme.surface,
                    hintText: "Ghi chú",
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.onSurface,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 300,
                  child: _buildListDishItem(),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.onSurface,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Mã giảm giá: ' +
                                    (discountCode != null
                                        ? '-${discountCode.discount}%'
                                        : ''),
                                style: TextStyles.h3.merge(
                                  TextStyle(color: colorScheme.onBackground),
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: discountCode != null
                                  ? Text(
                                      '${discountCode.code} - ${discountCode.name}',
                                      style: TextStyles.h5.merge(
                                        TextStyle(color: colorScheme.onSurface),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    )
                                  : Text(
                                      'Chưa nhập mã giảm giá!',
                                      style: TextStyles.h5.merge(
                                        TextStyle(color: colorScheme.onSurface),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 30),
                        child: CupertinoButton(
                          child: Text(
                            discountCode != null ? 'Đổi' : 'Thêm',
                            style: TextStyles.h5.merge(
                              TextStyle(color: colorScheme.primary),
                            ),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          minSize: 0,
                          color: colorScheme.surface,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          onPressed: () {
                            if (_authenticationBloc.currentState
                                is AuthenticationAuthenticated) {
                              showInputDiscountBottomSheet(context);
                            } else {
                              showLoginAlert(_scaffoldKey.currentContext,
                                  _authenticationBloc, _loginBloc);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.onSurface,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, right: 8, bottom: 8),
                              child: Text(
                                'Voucher:' +
                                    ' ' +
                                    (voucherCode == null
                                        ? ''
                                        : '-' +
                                            voucherCode.value.toString() +
                                            (voucherCode.isPercent == true
                                                ? '%'
                                                : ' VNĐ')),
                                style: TextStyles.h3.merge(
                                  TextStyle(color: colorScheme.onBackground),
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                            child: CupertinoButton(
                              child: Text(
                                voucherCode == null ? 'Chọn' : 'Đổi',
                                style: TextStyles.h5.merge(
                                  TextStyle(color: colorScheme.primary),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              minSize: 0,
                              color: colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              onPressed: () {
                                if (_authenticationBloc.currentState
                                    is AuthenticationAuthenticated) {
                                  showVoucherBottomSheet(context);
                                } else {
                                  showLoginAlert(_scaffoldKey.currentContext,
                                      _authenticationBloc, _loginBloc);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 5, right: 8, bottom: 8),
                        child: Text(
                          voucherCode == null
                              ? 'Chưa chọn voucher!'
                              : voucherCode.name,
                          style: TextStyles.h5.merge(
                            TextStyle(color: colorScheme.onSurface),
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.onSurface,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Địa chỉ:',
                                style: TextStyles.h3.merge(
                                  TextStyle(color: colorScheme.onBackground),
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                billAddress == null
                                    ? 'Chưa chọn địa chỉ!'
                                    : billAddress.address,
                                style: TextStyles.h5.merge(
                                  TextStyle(color: colorScheme.onSurface),
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 10, 30),
                        child: CupertinoButton(
                          child: Text(
                            billAddress == null ? 'Chọn' : 'Đổi',
                            style: TextStyles.h5.merge(
                              TextStyle(color: colorScheme.primary),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          minSize: 0,
                          color: colorScheme.surface,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          onPressed: () {
                            showAddressBottomSheet(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                DashedContainer(
                  dashColor: colorScheme.primary,
                  borderRadius: 15.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Thành tiền:',
                              style: TextStyles.h3.merge(
                                TextStyle(color: colorScheme.onBackground),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            discountPrice < price
                                ? Text(
                                    '${price.floor().toString()} VNĐ',
                                    style: TextStyles.h4.merge(
                                      TextStyle(
                                          color: colorScheme.onSurface,
                                          fontStyle: FontStyle.italic,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                    textAlign: TextAlign.right,
                                  )
                                : Container(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${discountPrice.floor().toString()} VNĐ',
                              style: TextStyles.h2Bold.merge(
                                TextStyle(color: colorScheme.onBackground),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    gradient: GradientColor.of(context).primaryGradient,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: BlocBuilder(
                    bloc: _cartBloc,
                    builder: (context, state) {
                      return CupertinoButton(
                        child: SizedBox(
                          height: 20,
                          child: state is CartBlocCreatingBill
                              ? SizedBox(
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        colorScheme.onPrimary),
                                  ),
                                )
                              : Text(
                                  'Tạo hóa đơn',
                                  style: TextStyles.h3.merge(
                                    TextStyle(color: colorScheme.onPrimary),
                                  ),
                                ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        minSize: 0,
                        onPressed: () {
                          if (_authenticationBloc.currentState
                              is AuthenticationAuthenticated) {
                            _cartBloc.dispatch(CreateBillFromCart());
                          } else {
                            showLoginAlert(_scaffoldKey.currentContext,
                                _authenticationBloc, _loginBloc);
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListDishItem() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: dishItems.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0)
          return Column(
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Dismissible(
                key: Key(index.toString()),
                onDismissed: (direct) {
                  onDismissed(dishItems[index].dishId);
                },
                child: CartItem(
                  cartDish: dishItems[index],
                  borderRadius: 10,
                ),
              ),
            ],
          );
        return Dismissible(
          key: Key(index.toString()),
          onDismissed: (direct) {
            onDismissed(dishItems[index].dishId);
          },
          child: CartItem(
            cartDish: dishItems[index],
            borderRadius: 10,
          ),
        );
      },
    );
  }

  void onDismissed(int dishId) {
    _cartBloc.dispatch(RemoveDishFromCart(dishId));
  }
}

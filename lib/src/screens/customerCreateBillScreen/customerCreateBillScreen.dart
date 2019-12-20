import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/fakeAddress.dart';
import 'package:resman_mobile_customer/src/fakeVoucher.dart';
import 'package:resman_mobile_customer/src/screens/customerCreateBillScreen/billDishItem.dart';
import 'package:resman_mobile_customer/src/utils/gradientColor.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:resman_mobile_customer/src/widgets/AppBars/backAppBar.dart';
import 'package:resman_mobile_customer/src/widgets/bottomSheet/showAddressBottomSheet.dart';
import 'package:resman_mobile_customer/src/widgets/bottomSheet/showVoucherBottomSheet.dart';
import 'package:resman_mobile_customer/src/widgets/drawerScaffold.dart';

import '../../FakeBillItem.dart';

class CustomerCreateBillScreen extends StatefulWidget {
  @override
  _CustomerCreateBillScreen createState() => _CustomerCreateBillScreen();
}

class _CustomerCreateBillScreen extends State<CustomerCreateBillScreen> {
  List<DishItem> dishItems;
  Address billAddress;
  Voucher billVoucher;
  List<Voucher> vouchers;
  String _value = '';
  bool addSuccess = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    dishItems = FakeBillItem.dishItems;
    vouchers = FakeVoucher.vouchers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return DrawerScaffold(
      key: _scaffoldKey,
      appBar: BackAppBar(
        showShoppingCart: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    style: TextStyles.h5
                        .merge(TextStyle(color: colorScheme.onBackground)),
                    scrollPhysics: BouncingScrollPhysics(),
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.onSurface,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: _buildListDishItem(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
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
                                'Discount:',
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
                              child: _value.isNotEmpty
                                  ? Text(
                                      _value,
                                      style: TextStyles.h5.merge(
                                        TextStyle(color: colorScheme.onSurface),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    )
                                  : Text(
                                      'No discount code provided!',
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
                            'Add',
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
                            _showInputDiscountBottomSheet();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
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
                                    (billVoucher == null
                                        ? ''
                                        : billVoucher.value.toString() +
                                            (billVoucher.isPercent == true
                                                ? ' %'
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
                                'change',
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
                                _showVoucherBottomSheet();
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 5, right: 8, bottom: 8),
                        child: Text(
                          billVoucher == null
                              ? 'No voucher is provided!'
                              : billVoucher.name,
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
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
                                'Address:',
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
                                    ? 'No address is provided!'
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
                            'Change',
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
                            _showAddressBottomSheet();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DashedContainer(
                  dashColor: colorScheme.primary,
                  borderRadius: 15.0,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 20, 15),
                          child: Text(
                            'Total amount:',
                            style: TextStyles.h3.merge(
                              TextStyle(color: colorScheme.onBackground),
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Text(
                              '5000000 VNĐ',
                              style: TextStyles.h2Bold.merge(
                                TextStyle(color: colorScheme.onBackground),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: GradientColor.of(context).primaryGradient,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: CupertinoButton(
                    child: Text(
                      'Tạo hóa đơn',
                      style: TextStyles.h3.merge(
                        TextStyle(color: colorScheme.onPrimary),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    minSize: 0,
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      ),
    );
  }

  _showInputDiscountBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      context: context,
      builder: (context) {
        var colorScheme = Theme.of(context).colorScheme;
        return Form(
          key: _formKey,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Wrap(
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Text(
                    'Discount code',
                    style: TextStyles.h2Bold
                        .merge(TextStyle(color: colorScheme.onBackground)),
                  ),
                  Center(
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        filled: true,
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter code here...',
                        hintStyle: TextStyles.h5
                            .merge(TextStyle(color: colorScheme.onSurface)),
                      ),
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Không được để trống trường này';
                        }
                        if (value.length > 10) {
                          return 'Giá trị nhập vào tối đa 10 ký tự';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        print(value);
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: GradientColor.of(context).primaryGradient,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CupertinoButton(
                            child: Text(
                              'Save',
                              style: TextStyles.h5
                                  .merge(TextStyle(color: colorScheme.surface)),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 100),
                            minSize: 0,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Navigator.pop(context);
                                _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(content: Text('Thêm thành công')));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showAddressBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      context: context,
      builder: (context) {
        return AddressBottomSheet(
            selectedAddress: billAddress,
            onSelect: (address) {
              setState(() {
                billAddress = address;
              });
            });
      },
    );
  }

  _showVoucherBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) {
          return VoucherBottomSheet(
            selectedVoucher: billVoucher,
            onSelectVoucher: (voucher) {
              setState(() {
                billVoucher = voucher;
              });
            },
          );
        });
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
              BillDishItem(
                dishItem: dishItems[index],
              ),
            ],
          );
        return BillDishItem(
          dishItem: dishItems[index],
        );
      },
    );
  }
}

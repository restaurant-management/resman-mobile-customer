import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:resman_mobile_customer/src/widgets/bottomSheet/voucherBottomSheet.dart';

import '../../fakeVoucher.dart';

class VoucherBottomSheet extends StatefulWidget {
  final Voucher selectedVoucher;
  final Function(Voucher) onSelectVoucher;

  const VoucherBottomSheet({Key key, this.selectedVoucher, this.onSelectVoucher})
      : super(key: key);

  @override
  _VoucherBottomSheetState createState() => _VoucherBottomSheetState();
}

class _VoucherBottomSheetState extends State<VoucherBottomSheet> {
  List<Voucher> vouchers;

  @override
  void initState() {
    vouchers = FakeVoucher.vouchers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Form(
      child: Container(
        child: Wrap(
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Chọn voucher',
                style: TextStyles.h2Bold
                    .merge(TextStyle(color: colorScheme.onBackground)),
              ),
            ),
            Container(
              height: 150,
              child: _buildListVoucher(
                vouchers,
                widget.selectedVoucher,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildListVoucher(List<Voucher> vouchers, [Voucher selected]) {
    return ListView.builder(
        itemCount: vouchers.length,
        itemBuilder: (BuildContext context, int index) {
          bool isBlue = false;
          if (vouchers[index] == selected) {
            isBlue = true;
          }
          if (index == 0)
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                VoucherBottomSheetItem(
                  voucher: vouchers[index],
                  isBlue: isBlue,
                  onTap: (voucher) {
                    Navigator.pop(context);
                    widget.onSelectVoucher?.call(voucher);
                  },
                ),
              ],
            );
          return VoucherBottomSheetItem(
            voucher: vouchers[index],
            isBlue: isBlue,
            onTap: (voucher) {
              Navigator.pop(context);
              widget.onSelectVoucher?.call(voucher);
            },
          );
        });
  }
}



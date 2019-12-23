import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/state.dart';
import 'package:resman_mobile_customer/src/models/voucherCode.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:resman_mobile_customer/src/widgets/bottomSheet/voucherBottomSheetItem.dart';
import 'package:resman_mobile_customer/src/widgets/errorIndicator.dart';
import 'package:resman_mobile_customer/src/widgets/loadingIndicator.dart';

class VoucherBottomSheet extends StatefulWidget {
  final VoucherCode selectedVoucher;
  final Function(VoucherCode) onSelectVoucher;

  const VoucherBottomSheet(
      {Key key, this.selectedVoucher, this.onSelectVoucher})
      : super(key: key);

  @override
  _VoucherBottomSheetState createState() => _VoucherBottomSheetState();
}

class _VoucherBottomSheetState extends State<VoucherBottomSheet> {
  CurrentUserBloc userBloc = CurrentUserBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Wrap(
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
          child: BlocBuilder(
            bloc: userBloc,
            builder: (context, state) {
              if (state is CurrentUserProfileFetched) {
                return _buildListVoucher(state.user.voucherCodes, widget.selectedVoucher);
              } else if (state is CurrentUserProfileFetchFailure) {
                return ErrorIndicator();
              }

              return LoadingIndicator();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListVoucher(List<VoucherCode> vouchers, [VoucherCode selected]) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
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
                    widget.onSelectVoucher?.call(voucher);
                    Navigator.pop(context);
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

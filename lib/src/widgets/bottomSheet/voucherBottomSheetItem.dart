import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:resman_mobile_customer/src/models/voucherCode.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

class VoucherBottomSheetItem extends StatefulWidget {
  final VoucherCode voucher;
  final bool isBlue;
  final Function(VoucherCode) onTap;

  const VoucherBottomSheetItem({Key key, this.voucher, this.isBlue = false, this.onTap}) : super(key: key);

  @override
  _VoucherBottomSheet createState() => _VoucherBottomSheet();
}

class _VoucherBottomSheet extends State<VoucherBottomSheetItem> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            widget.onTap?.call(widget.voucher);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: colorScheme.surface),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    MdiIcons.brightnessPercent,
                    color: widget.isBlue?colorScheme.primary :colorScheme.onSurface,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.voucher.name,
                      style: TextStyles.h4
                          .merge(TextStyle(color: widget.isBlue?colorScheme.primary :colorScheme.onSurface)),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.voucher.value.toString() + '%',
                    style: TextStyles.h5.merge(TextStyle(
                      color: widget.isBlue?colorScheme.primary :colorScheme.onSurface,
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

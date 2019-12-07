import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/fakeAddress.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

class AddressBottomSheetItem extends StatefulWidget {
  final Address address;
  final bool isBlue;
  final Function(Address) onTap;

  const AddressBottomSheetItem({Key key, this.address, this.isBlue = false, this.onTap})
      : super(key: key);

  @override
  _AddressBottomSheetItemState createState() => _AddressBottomSheetItemState();
}

class _AddressBottomSheetItemState extends State<AddressBottomSheetItem> {
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
            widget.onTap?.call(widget.address);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 3, color: colorScheme.surface),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.directions,
                    color: widget.isBlue
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      widget.address.address,
                      style: TextStyles.h4.merge(TextStyle(
                          color: widget.isBlue
                              ? colorScheme.primary
                              : colorScheme.onSurface)),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

import '../../fakeAddress.dart';
import 'addressBottomSheetItem.dart';

class AddressBottomSheet extends StatefulWidget {
  final Address selectedAddress;
  final Function(Address) onSelect;

  const AddressBottomSheet({Key key, this.selectedAddress, this.onSelect})
      : super(key: key);

  @override
  _AddressBottomSheetState createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  List<Address> addresses;

  @override
  void initState() {
    addresses = FakeAddress.addresses;
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: Wrap(
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Chọn địa chỉ',
              style: TextStyles.h2Bold
                  .merge(TextStyle(color: colorScheme.onBackground)),
            ),
          ),
          Container(
            height: 150,
            child: _buildListAddress(
              addresses,
              widget.selectedAddress,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListAddress(List<Address> addresses, [Address selected]) {
    return ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (BuildContext context, int index) {
        bool isBlue = false;
        if (addresses[index] == selected) {
          isBlue = true;
        }

        if (index == 0)
          return Column(
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              AddressBottomSheetItem(
                address: addresses[index],
                isBlue: isBlue,
                onTap: (address) {
                  Navigator.pop(context);
                  widget.onSelect?.call(address);
                },
              ),
            ],
          );
        return AddressBottomSheetItem(
          address: addresses[index],
          isBlue: isBlue,
          onTap: (address) {
            Navigator.pop(context);
            widget.onSelect?.call(address);
          },
        );
      },
    );
  }
}

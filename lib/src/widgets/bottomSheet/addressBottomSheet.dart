import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/state.dart';
import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

import '../errorIndicator.dart';
import '../loadingIndicator.dart';
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
  CurrentUserBloc userBloc = CurrentUserBloc();

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
            child: BlocBuilder(
              bloc: userBloc,
              builder: (context, state) {
                if (state is CurrentUserProfileFetched) {
                  return _buildListAddress(
                      state.user.addresses, widget.selectedAddress);
                } else if (state is CurrentUserProfileFetchFailure) {
                  return ErrorIndicator();
                }

                return LoadingIndicator();
              },
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

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/state.dart';
import 'package:resman_mobile_customer/src/blocs/editProfileBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/editProfileBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/editProfileBloc/state.dart';
import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/models/userModel.dart';
import 'package:resman_mobile_customer/src/utils/gradientColor.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:resman_mobile_customer/src/widgets/loadingIndicator.dart';
import 'package:resman_mobile_customer/src/utils/extensions.dart';

import '../../widgets/AppBars/backAppBar.dart';
import '../../widgets/drawerScaffold.dart';

class EditProfileScreen extends StatelessWidget {
  final CurrentUserBloc _currentUserBloc = CurrentUserBloc();

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
        appBar: BackAppBar(
          showShoppingCart: false,
        ),
        body: BlocBuilder(
          bloc: _currentUserBloc,
          builder: (BuildContext context, CurrentUserState state) {
            if (state is CurrentUserProfileFetched)
              return EditProfileForm(
                currentUser: state.user,
              );
            return LoadingIndicator();
          },
        ));
  }
}

class EditProfileForm extends StatefulWidget {
  final UserModel currentUser;

  const EditProfileForm({Key key, @required this.currentUser})
      : assert(currentUser != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfileForm> {
  List<Address> _addresses;
  final _formKey = GlobalKey<FormState>();
  Address _address;
  String _name;
  String _email;
  String _phoneNumber;
  String _oldAvatar;
  File _newAvatar;
  DateTime _birthday;
  bool isSaving;
  final _birthdayTextFieldController = new TextEditingController();
  final EditProfileBloc _editProfileBloc = EditProfileBloc();
  var formKey = GlobalKey<FormState>();

  UserModel get currentUser => widget.currentUser;

  @override
  void initState() {
    isSaving = false;
    _addresses = currentUser.addresses;
    _address = null;
    _birthday = currentUser.birthday;
    _name = currentUser.fullName;
    _email = currentUser.email;
    _phoneNumber = currentUser.phoneNumber;
    _oldAvatar = currentUser.avatar;
    if (_birthday != null)
      _birthdayTextFieldController.text =
          DateFormat('dd/MM/yyyy').format(_birthday);
    super.initState();
  }

  Future pickImageByCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _newAvatar = tempImage;
    });
  }

  Future pickImageByGallery() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _newAvatar = tempImage;
    });
  }

  @override
  void dispose() {
    _editProfileBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocListener(
      bloc: _editProfileBloc,
      listener: (BuildContext context, state) {
        if (state is EditProfileBlocSaved)
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Cập nhật thành công.'),
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
        if (state is EditProfileBlocSaveFailure)
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Xảy ra lỗi trong quá trình cập nhật.'),
              backgroundColor: Colors.red,
            ),
          );
        if (state is EditProfileBlocUploadAvatarFailure)
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Xảy ra lỗi trong tải lên ảnh đại diện.'),
              backgroundColor: Colors.red,
            ),
          );
        if (state is EditProfileBlocUploadingAvatar ||
            state is EditProfileBlocUploadedAvatar ||
            state is EditProfileBlocSaving)
          setState(() {
            isSaving = true;
          });
        else
          setState(() {
            isSaving = false;
          });
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Stack(children: [
              Container(
                width: 150.0,
                height: 150.0,
                padding: const EdgeInsets.all(4.0),
                decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: _newAvatar != null
                      ? Image.file(
                          _newAvatar,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return Image.asset(
                              'assets/images/default-avatar.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                          imageUrl: _oldAvatar,
                        ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipOval(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor.withAlpha(80),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                title: Text('Chọn cách nhập ảnh:'),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text('Máy ảnh'),
                                    onPressed: () {
                                      pickImageByCamera().then((value) {
                                        Navigator.pop(context, 'Cancel');
                                      });
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text('Thư viện'),
                                    onPressed: () {
                                      pickImageByGallery().then((value) {
                                        Navigator.pop(context, 'Cancel');
                                      });
                                    },
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text('Huỷ chọn ảnh'),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
              ),
            ]),
            Form(
              key: formKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              initialValue: _name,
                              style: TextStyle(color: colorScheme.onBackground),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.contact_mail,
                                  color: primaryColor,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                labelText: 'Họ và tên',
                                labelStyle:
                                    TextStyle(color: colorScheme.onBackground),
                              ),
                              onFieldSubmitted: (value) {
                                setState(() {
                                  _name = value;
                                });
                              },
                            ),
                            TextFormField(
                              initialValue: _email,
                              style: TextStyle(color: colorScheme.onBackground),
                              enabled: false,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: primaryColor,
                                  ),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      color: colorScheme.onBackground)),
                            ),
                            TextFormField(
                              initialValue: _phoneNumber,
                              style: TextStyle(color: colorScheme.onBackground),
                              onFieldSubmitted: (value) {
                                setState(() {
                                  _phoneNumber = value;
                                });
                              },
                              autovalidate: true,
                              keyboardType: TextInputType.numberWithOptions(),
                              validator: (value) {
                                if (value != null && !value.isPhoneNumber()) {
                                  return 'Số điện thoại không đúng định dạng';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: primaryColor,
                                  ),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  labelText: 'Số điện thoại',
                                  labelStyle: TextStyle(
                                      color: colorScheme.onBackground)),
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _birthdayTextFieldController,
                                  enabled: false,
                                  style: TextStyle(
                                      color: colorScheme.onBackground),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
                                        color: primaryColor,
                                      ),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      labelText: 'Ngày sinh',
                                      labelStyle: TextStyle(
                                          color: colorScheme.onBackground)),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 45.0,
                                  decoration: BoxDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        13, 15, 20, 15),
                                    child: Icon(
                                      Icons.directions,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        AnimatedContainer(
                                          constraints: BoxConstraints(
                                            maxHeight: 100,
                                            minHeight: 15,
                                          ),
                                          duration: Duration(
                                            milliseconds: 200,
                                          ),
                                          child: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            child: Column(
                                                children: _buildListAddress()),
                                          ),
                                        ),
                                        CupertinoButton(
                                          child: Icon(
                                            Icons.add,
                                            color: primaryColor,
                                          ),
                                          color: Colors.grey[300],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 100),
                                          minSize: 0,
                                          onPressed: () {
                                            _showModalBottomSheet();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            GradientButton(
                              increaseWidthBy: 50,
                              child: Text('Lưu'),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  !isSaving
                                      ? Theme.of(context).primaryColor
                                      : Color.fromRGBO(0, 0, 0, 0.3),
                                  !isSaving
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryVariant
                                      : Color.fromRGBO(0, 0, 0, 0.3),
                                ],
                                stops: [0.1, 1.0],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              ),
                              callback: () {
                                if (formKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  if (!isSaving)
                                    _editProfileBloc.dispatch(SaveNewProfile(
                                        currentUser,
                                        _name,
                                        _birthday,
                                        _email,
                                        _newAvatar != null ? _newAvatar : null,
                                        _addresses,
                                        _phoneNumber));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showModalBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      context: context,
      builder: (BuildContext context) {
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
                    'Thêm địa chỉ',
                    style: TextStyles.h2Bold
                        .merge(TextStyle(color: colorScheme.onBackground)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Nhập địa chỉ...',
                      hintStyle: TextStyles.h5
                          .merge(TextStyle(color: colorScheme.onSurface)),
                    ),
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Không được để trống trường này';
                      }
                      if (value.length <= 10) {
                        return 'Giá trị nhập vào không nhỏ hơn 10 ký tự';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _address = Address(address: value);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            gradient: GradientColor.of(context).primaryGradient,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: CupertinoButton(
                            child: Text(
                              'Thêm',
                              style: TextStyles.h5
                                  .merge(TextStyle(color: colorScheme.surface)),
                            ),
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 100),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            minSize: 0,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _addresses.add(_address);
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
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

  List<Widget> _buildListAddress() {
    return _addresses
        .asMap()
        .map((index, _value) => MapEntry(
            index,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _value.address,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.all(0),
                    minSize: 0,
                    child: Icon(Icons.indeterminate_check_box),
                    onPressed: () {
                      setState(() {
                        _addresses.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            )))
        .values
        .toList();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _birthday ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2020));
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
      });
      _birthdayTextFieldController.text =
          DateFormat('dd/MM/yyyy').format(_birthday);
    }
  }
}

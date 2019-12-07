import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/currentUserBloc/state.dart';
import 'package:resman_mobile_customer/src/enums/permission.dart';
import 'package:resman_mobile_customer/src/models/userModel.dart';
import 'package:resman_mobile_customer/src/screens/storeSelectionScreen/storeSelectionScreen.dart'
    show Store, StoreSelectionScreen;
import 'package:resman_mobile_customer/src/widgets/errorIndicator.dart';
import 'package:resman_mobile_customer/src/widgets/loadingIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../blocs/authenticationBloc/bloc.dart';
import '../../blocs/authenticationBloc/event.dart';
import '../../blocs/authenticationBloc/state.dart';
import '../billsScreen/billScreen.dart';
import '../editProfileScreen/editPasswordScreen.dart';
import '../editProfileScreen/editProfileScreen.dart';
import '../loginScreen/loginScreen.dart';
import 'profileScreen.dart';
import 'package:resman_mobile_customer/src/models/storeModal.dart';

Future<Store> getStoreDetail(int storeId) async {
  print('Fetching...');
  final response = await http
      .get('http://resman-web-admin-api.herokuapp.com/api/stores/$storeId');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    // TODO map json.decode
    return Store.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    String message;
    try {
      message = jsonDecode(response.body)['message'];
    } catch (e) {
      print('Error: $e');
    }
    if (message != null && message.isNotEmpty) throw Exception(message);
    throw Exception('Tải thông tin cửa hàng thất bại.');
  }
}

class ProfileDrawer extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;

  const ProfileDrawer({Key key, @required this.authenticationBloc})
      : assert(authenticationBloc != null),
        super(key: key);

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  CurrentUserBloc _currentUserBloc = CurrentUserBloc();
  Widget storeLogo;
  Future<Store> store;

  @override
  void initState() {
    storeLogo = SvgPicture.asset(
      'assets/icons/res-icon-2.svg',
      width: 30,
      height: 30,
    );
    SharedPreferences.getInstance().then((value) {
      SharedPreferences prefs = value;
      if (prefs.containsKey('store')) {
        var storeId = prefs.getInt('store');
        store = getStoreDetail(storeId);
        store.then((value) {
          setState(() {
            storeLogo = CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(value.logo),
            );
          });
        }).catchError((e) {
          print(e);
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget.authenticationBloc,
      builder: (BuildContext context, state) {
        if (state is AuthenticationAuthenticated) {
          return Drawer(
            child: BlocBuilder(
              bloc: _currentUserBloc,
              builder: (BuildContext context, state) {
                if (state is CurrentUserProfileFetched)
                  return _buildContent(state.user);
                if (state is CurrentUserProfileFetchFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ErrorIndicator(
                        message: 'Tải thông tin thất bại!',
                        reloadOnPressed: () {
                          _currentUserBloc.dispatch(FetchCurrentUserProfile());
                        },
                      ),
                      FlatButton(
                        onPressed: () {
                          widget.authenticationBloc.dispatch(LoggedOut());
                        },
                        child: Text('Đăng xuất'),
                      )
                    ],
                  );
                }
                return LoadingIndicator();
              },
            ),
          );
        }
        return Drawer(
          child: _buildContent(),
        );
      },
    );
  }

  Widget _buildContent([UserModel user]) {
    return ListView(
      children: <Widget>[
        Stack(children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(
              user?.email ?? '',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            accountName: Text(
              user?.fullName ?? user?.username ?? '',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            currentAccountPicture: GestureDetector(
              onTap: () {},
              child: Container(
                  child: InkWell(
                    onTap: () {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              user: user,
                            ),
                          ),
                        );
                      }
                    },
                    child: Hero(
                      tag: "avatarHero",
                      child: ClipOval(
                        child: user?.avatar != null
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/default-avatar.jpg',
                                fit: BoxFit.cover,
                                image: user?.avatar,
                              )
                            : Image.asset(
                                'assets/images/default-avatar.jpg',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  width: 32.0,
                  height: 32.0,
                  padding: const EdgeInsets.all(2.0),
                  decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor, // border color
                    shape: BoxShape.circle,
                  )),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/cover.jpg'),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreSelectionScreen(),
                      ),
                    );
                  },
                  child: storeLogo,
                ),
              ),
              width: 50.0,
              height: 50.0,
              padding: const EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary, // border color
                shape: BoxShape.circle,
              ),
            ),
          )
        ]),
        ..._buildChangeAuthenticatedAndUnauthenticated(
            isAuth: user != null ? true : false),
      ],
    );
  }

  List<Widget> _buildChangeAuthenticatedAndUnauthenticated(
      {bool isAuth = false}) {
    if (isAuth)
      return [
        ListTile(
          leading: Icon(
            Icons.description,
            color: Colors.pinkAccent,
          ),
          title: Text(
            'Hoá đơn của tôi',
            style: TextStyle(color: Colors.pinkAccent, fontSize: 16),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BillsScreen(
                          isMyBill: true,
                        )));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.assignment_ind,
            color: Colors.teal,
          ),
          title: Text(
            'Sửa thông tin',
            style: TextStyle(color: Colors.teal, fontSize: 16),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.lock,
            color: Colors.deepPurple,
          ),
          title: Text(
            'Đổi mật khẩu',
            style: TextStyle(color: Colors.deepPurple, fontSize: 16),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditPasswordScreen(
//                      currentUser: user,
                        )));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.keyboard_return,
            color: Colors.deepOrange,
          ),
          title: Text(
            'Đăng xuất',
            style: TextStyle(color: Colors.deepOrange, fontSize: 16),
          ),
          onTap: () {
            widget.authenticationBloc.dispatch(LoggedOut());
          },
        )
      ];
    else
      return [
        ListTile(
          leading: Icon(
            Icons.event_available,
            color: Colors.pinkAccent,
            size: 30,
          ),
          title: Text(
            'Đăng nhập',
            style: TextStyle(color: Colors.pinkAccent, fontSize: 16),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
                    authenticationBloc: widget.authenticationBloc,
                  ),
                ));
          },
        ),
        ListTile(
          leading: Icon(
            Icons.add_box,
            color: Colors.teal,
            size: 30,
          ),
          title: Text(
            'Đăng ký',
            style: TextStyle(color: Colors.teal, fontSize: 16),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
                    authenticationBloc: widget.authenticationBloc,
                  ),
                ));
          },
        ),
      ];
  }

  bool haveUpdateBillStatusPermission(List<Permission> permissions) {
    return permissions.indexOf(Permission.billManagement) >= 0 ||
        permissions.indexOf(Permission.updateCompleteBillStatus) >= 0 ||
        permissions.indexOf(Permission.updateDeliveringBillStatus) >= 0 ||
        permissions.indexOf(Permission.updatePrepareDoneBillStatus) >= 0 ||
        permissions.indexOf(Permission.updatePreparingBillStatus) >= 0 ||
        permissions.indexOf(Permission.updateShippingBillStatus) >= 0 ||
        permissions.indexOf(Permission.updatePaidBillStatus) >= 0;
  }
}

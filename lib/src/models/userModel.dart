import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:resman_mobile_customer/src/models/address.dart';
import 'package:resman_mobile_customer/src/models/voucherCode.dart';

class UserModel extends Equatable {
  String _uuid;
  String _username;
  String _fullName;
  String _avatar;
  String _email;
  DateTime _birthday;
  String _role;
  List<int> _favouriteDishes;
  List<VoucherCode> _voucherCodes = [];
  List<Address> _addresses = [];

  String get uuid => _uuid;

  String get username => _username;

  String get fullName => _fullName;

  String get email => _email;

  String get avatar => _avatar;

  DateTime get birthday => _birthday;

  String get role => _role;

  List<int> get favouriteDishes => _favouriteDishes;

  List<VoucherCode> get voucherCodes => _voucherCodes;

  List<Address> get addresses => _addresses;

  UserModel.fromJson(Map<String, dynamic> json) {
    _uuid = json['uuid'];
    _username = json['username'];
    _fullName = json['fullName'];
    _email = json['email'];
    _avatar = json['avatar'] ?? '';
    _birthday = json['birthday'] != null
        ? DateFormat('yyyy-MM-dd').parse(json['birthday'])
        : null;
    _role = json['role'];
    _voucherCodes = (json['voucherCodes'] as List<dynamic>)
        .map((e) => VoucherCode.fromJson(e))
        .toList();
    _addresses = (json['addresses'] as List<dynamic>)
        .map((e) => Address.fromJson(e))
        .toList();
    _favouriteDishes = json['favouriteDishes'] != null
        ? (json['favouriteDishes'] as List<dynamic>)
            .asMap()
            .map((index, item) {
              return MapEntry(index, int.tryParse(item['id'].toString()));
            })
            .values
            .toList()
        : [];
  }

  UserModel.empty() {
    _uuid = '';
    _username = 'username';
    _fullName = 'fullName';
    _avatar = '';
    _email = 'email@gmail.com';
    _birthday = DateTime.now();
    _role = '';
    _favouriteDishes = [];
  }

  @override
  String toString() {
    return '{uuid: $uuid, username: $username, fullName: $fullName, email: $email, birthday: $birthday, role: $role}';
  }
}

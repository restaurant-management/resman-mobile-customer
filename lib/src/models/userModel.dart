import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class UserModel extends Equatable {
  String _uuid;
  String _username;
  String _fullName;
  String _avatar;
  String _email;
  DateTime _birthday;
  String _role;
  List<int> _favouriteDishes;

  String get uuid => _uuid;

  String get username => _username;

  String get fullName => _fullName;

  String get email => _email;

  String get avatar => _avatar;

  DateTime get birthday => _birthday;

  String get role => _role;

  List<int> get favouriteDishes => _favouriteDishes;

  UserModel.fromJson(Map<String, dynamic> parsedJson) {
    _uuid = parsedJson['uuid'];
    _username = parsedJson['username'];
    _fullName = parsedJson['fullName'];
    _email = parsedJson['email'];
    _avatar = parsedJson['avatar'];
    _birthday = parsedJson['birthday'] != null
        ? DateFormat('yyyy-MM-dd').parse(parsedJson['birthday'])
        : null;
    _role = parsedJson['role'];
    _favouriteDishes = parsedJson['favouriteDishes'] != null
        ? (parsedJson['favouriteDishes'] as List<dynamic>)
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

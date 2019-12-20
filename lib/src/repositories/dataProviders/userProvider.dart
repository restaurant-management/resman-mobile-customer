import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:resman_mobile_customer/src/enums/permission.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphClient.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphQuery.dart';

import '../../models/userModel.dart';

class UserProvider {
  static String apiUrl = 'http://resman-web-admin-api.herokuapp.com';
  Client client = Client();

  Future<String> login(String usernameOrEmail, String password) async {
    print('Login...');
    final response = await (GraphClient()
          ..addBody(GraphQuery.login(usernameOrEmail, password)))
        .connect();
    return response['loginAsCustomer'];
  }

  Future<void> register(String username, String email, String password) async {
    print('Register...');
    final response = await client.post('$apiUrl/api/customers/register',
        body: {'username': username, 'password': password, 'email': email});
    if (response.statusCode != 200) {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Đăng ký thất bại.');
    }
  }

  Future<UserModel> getProfileByUsername(String username, String token) async {
    final response = await (GraphClient()
          ..authorization(token)
          ..addBody(GraphQuery.me))
        .connect();

    return UserModel.fromJson(response['meAsCustomer']);
  }

  Future<UserModel> getProfileByEmail(String email, String token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response = await client.get('$apiUrl/api/customers/email/$email',
        headers: headers);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Đăng nhập thất bại.');
    }
  }

  Future<UserModel> editUserProfile(String token, String username, String email,
      String fullName, DateTime birthday, String avatar) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    Map<String, String> body = {};
    if (birthday != null)
      body.addAll(
          {'birthday': DateFormat('yyyy-MM-dd').format(birthday).toString()});
    if (email != null) body.addAll({'email': email});
    if (fullName != null) body.addAll({'fullName': fullName});
    if (avatar != null) body.addAll({'avatar': avatar});

    final response = await client.put('$apiUrl/api/customers/$username',
        headers: headers, body: body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Sửa thông tin thất bại.');
    }
  }

  Future changePassword(String token, String username, String oldPassword,
      String newPassword) async {
    await (GraphClient()
          ..authorization(token)
          ..addBody(GraphQuery.changePassword(oldPassword, newPassword)))
        .connect();
  }

  Future<List<Permission>> getAllUserPermissions(String username,
      {String token = ''}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': token
    };
    final response = await client.get('$apiUrl/api/users/$username/permissions',
        headers: headers);

    if (response.statusCode == 200) {
      var jsonPermissions = jsonDecode(response.body);
      print(jsonPermissions);
      return Permission.fromListString(
          jsonPermissions.map<String>((e) => e.toString()).toList());
    } else {
      String message;
      try {
        message = jsonDecode(response.body)['message'];
      } catch (e) {
        print('Error: $e');
      }
      if (message != null && message.isNotEmpty) throw (message);
      throw ('Lấy danh sách tất cả quyền thất bại.');
    }
  }
}

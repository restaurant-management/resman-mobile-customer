import 'package:flutter/material.dart';

class Address {
  int _id;
  String _address;
  double _longitude;
  double _latitude;

  int get id => _id;
  String get address => _address;
  double get longitude => _longitude;
  double get latitude => _latitude;

  Address.fromJson(Map<String, dynamic> json) {
    _id = int.tryParse(json['id']) ?? json['id'];
    _address = json['address'];
    _longitude = double.tryParse(json['longitude'].toString());
    _latitude = double.tryParse(json['latitude'].toString());
  }

  Address(
      {@required String address, double longitude, double latitude, int id}) {
    _id = id;
    _address = address;
    _longitude = longitude;
    _latitude = latitude;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (_id != null) json.addAll({'id': _id});
    if (_address != null) json.addAll({'address': _address.toString()});
    if (_longitude != null) json.addAll({'longitude': _longitude});
    if (_latitude != null) json.addAll({'latitude': _latitude});
    return json;
  }

  Map<String, dynamic> toGraphQL() {
    final Map<String, dynamic> json = {};
    if (_id != null) json.addAll({'id': _id});
    if (_address != null) json.addAll({'address': '"${_address.toString()}"'});
    if (_longitude != null) json.addAll({'longitude': _longitude});
    if (_latitude != null) json.addAll({'latitude': _latitude});
    return json;
  }

  @override
  String toString() =>
      'Address {id: $id, longitude: $longitude, latitude: $latitude, address: $address}';
}

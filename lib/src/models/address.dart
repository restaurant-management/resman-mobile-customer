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

  Address.fromJson(Map<String, String> json) {
    _id = int.tryParse(json['id']) ?? json['id'];
    _address = json['address'];
    _longitude = double.tryParse(json['longitude']) ?? json['longitude'];
    _latitude = double.tryParse(json['latitude']) ?? json['latitude'];
  }

  Address(
      {@required String address, double longitude, double latitude, int id}) {
    _id = id;
    _address = address;
    _longitude = longitude;
    _latitude = latitude;
  }

  @override
  String toString() =>
      'Address {id: $id, longitude: $longitude, latitude: $latitude, address: $address}';
}

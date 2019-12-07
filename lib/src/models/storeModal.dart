import 'package:intl/intl.dart';

class Store {
  final int id;
  final String name;
  final String logo;
  final String address;
  final String description;
  final String hotline;
  final int amountDishes;
  final DateTime openTime;
  final DateTime closeTime;
  final double rating;

  Store({
    this.id,
    this.name,
    this.logo,
    this.address,
    this.description,
    this.hotline,
    this.amountDishes,
    this.openTime,
    this.closeTime,
    this.rating,
  });

  factory Store.fromJson(Map<String,dynamic> json){
    return Store(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      address: json['address'],
      description: json['description'],
      hotline: json['hoitline'],
      amountDishes: json['amountDishes'],
      openTime: DateFormat('hh:mm:ss').parse(json['openTime']),
      closeTime: DateFormat('hh:mm:ss').parse(json['closeTime']),
      rating: json['rating'],
    );
  }
}
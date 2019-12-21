import 'package:equatable/equatable.dart';

class DishModal extends Equatable {
  int _dishId;
  String _name;
  String _description;
  List<String> _images;
  int _defaultPrice;
  int _price;

  int get dishId => _dishId;

  String get name => _name;

  String get description => _description;

  List<String> get images => _images;

  int get defaultPrice => _defaultPrice;

  int get price => _price;

  DishModal.fromJson(Map<String, dynamic> json) {
    _dishId = int.tryParse(json['id'].toString()) ?? json['id'];
    _name = json['name'];
    _description = json['description'];
    _images = (json['images'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    _defaultPrice = json['defaultPrice'];
    _price = json['price'];
  }

  @override
  String toString() => '{dishId: $_dishId, name: $_name}';
}

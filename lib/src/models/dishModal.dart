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

  DishModal.fromJson(Map<String, dynamic> parsedJson) {
    _dishId = parsedJson['dishId'];
    _name = parsedJson['name'];
    _description = parsedJson['description'];
    _images = (parsedJson['images'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    _defaultPrice = parsedJson['defaultPrice'];
    _price = parsedJson['price'];
  }

  @override
  String toString() => '{dishId: $_dishId, name: $_name}';
}

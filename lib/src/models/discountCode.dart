class DiscountCode {
  final String code;
  final bool isActive;
  final String name;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
  final double minBillPrice;
  final double maxPriceDiscount;
  final int maxNumber;
  final int discount;
  final List<int> stores;

  DiscountCode(
      this.code,
      this.isActive,
      this.name,
      this.description,
      this.startAt,
      this.endAt,
      this.minBillPrice,
      this.maxPriceDiscount,
      this.discount,
      this.stores,
      this.maxNumber);

  static DiscountCode fromJson(Map<String, dynamic> json) {
    var code = json['code'];
    var isActive = json['isActive'] ?? false;
    var name = json['name'];
    var description = json['description'] ?? '';
    var startAt = DateTime.tryParse(json['startAt']);
    var endAt = DateTime.tryParse(json['endAt']);
    var minBillPrice = double.tryParse(json['minBillPrice'].toString());
    var maxPriceDiscount = double.tryParse(json['maxPriceDiscount'].toString());
    var discount = json['discount'];
    var maxNumber = json['maxNumber'];
    var stores = (json['stores'] as List<dynamic>)
        .map((e) => int.tryParse(e['id'].toString()))
        .toList();

    return DiscountCode(code, isActive, name, description, startAt, endAt,
        minBillPrice, maxPriceDiscount, discount, stores, maxNumber);
  }
}

class VoucherCode {
  final String code;
  final bool isActive;
  final bool isPercent;
  final String name;
  final String description;
  final String image;
  final DateTime startAt;
  final DateTime endAt;
  final double minBillPrice;
  final double maxPriceDiscount;
  final int value;
  final List<int> stores;

  VoucherCode(
      this.code,
      this.isActive,
      this.isPercent,
      this.name,
      this.description,
      this.image,
      this.startAt,
      this.endAt,
      this.minBillPrice,
      this.maxPriceDiscount,
      this.value,
      this.stores);

  static VoucherCode fromJson(Map<String, dynamic> json) {
    var code = json['code'];
    var isActive = json['isActive'] ?? false;
    var isPercent = json['isPercent'] ?? false;
    var name = json['name'];
    var description = json['description'] ?? '';
    var image = json['image'] ?? '';
    var startAt = DateTime.tryParse(json['startAt']);
    var endAt = DateTime.tryParse(json['endAt']);
    var minBillPrice = json['minBillPrice'];
    var maxPriceDiscount = json['maxPriceDiscount'];
    var value = json['value'];
    var stores = (json['stores'] as List<dynamic>)
        .map((e) => int.tryParse(e['id'].toString()))
        .toList();

    return VoucherCode(code, isActive, isPercent, name, description, image,
        startAt, endAt, minBillPrice, maxPriceDiscount, value, stores);
  }
}

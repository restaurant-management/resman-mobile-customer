class Voucher{
  final String name;
  final double value;
  final bool isPercent;

  Voucher({this.name, this.value, this.isPercent = false});
}
class FakeVoucher{
  static final vouchers = [
    Voucher(
      name: 'Free cho Nguyên đại ca',
      value: 100,

    ),
    Voucher(
      name: 'Ưu đãi cho Hiển biến thái',
      value: 10,
      isPercent: true,
    ),
    Voucher(
      name: 'Không giảm cho Duy damdang, bụng bự đit teo,adasdasdasdsadasdasdsa',
      value: 1,
      isPercent: true,
    ),
  ];
}
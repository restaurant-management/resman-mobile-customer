import 'package:resman_mobile_customer/src/models/discountCode.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphClient.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphQuery.dart';

class DiscountCodeProvider {
  Future<DiscountCode> getDiscountCode(String code) async {
    final data = await (GraphClient()
          ..addBody(GraphQuery.getDiscountCode(code)))
        .connect();

    return DiscountCode.fromJson(data['getDiscountCode']);
  }
}

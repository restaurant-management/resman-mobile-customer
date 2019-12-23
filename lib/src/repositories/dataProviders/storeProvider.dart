import 'package:resman_mobile_customer/src/models/storeModal.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphClient.dart';
import 'package:resman_mobile_customer/src/repositories/dataProviders/graphQuery.dart';

class StoreProvider {
  Future<Store> fetchStore(int id) async {
    print('Fetching store $id ...');
    final data =
        await (GraphClient()..addBody(GraphQuery.getStore(id))).connect();

    return Store.fromJson(data['getStore']);
  }

  Future<List<Store>> getAll() async {
    print('Get all store ...');
    final data =
        await (GraphClient()..addBody(GraphQuery.getAllStore())).connect();

    return (data['stores'] as List<dynamic>)
        .asMap()
        .map((index, json) => MapEntry(index, Store.fromJson(json)))
        .values
        .toList();
  }
}

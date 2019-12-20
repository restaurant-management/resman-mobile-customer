import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:resman_mobile_customer/src/models/storeModal.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';
import 'package:resman_mobile_customer/src/screens/storeSelectionScreen/storeItem.dart';
import 'package:resman_mobile_customer/src/widgets/AppBars/backAppBar.dart';

import 'storeItem.dart';

Future<List<Store>> getAll() async {
  final response =
      await http.get('http://resman-web-admin-api.herokuapp.com/api/stores/');
  if (response.statusCode == 200) {
    List<Store> result = [];
    List<dynamic> list = jsonDecode(response.body);
    for (int i = 0; i < list.length; i++) {
      var store = Store.fromJson(list[i]);
      result.add(store);
    }
    return result;
  } else {
    String message;
    try {
      message = jsonDecode(response.body)['message'];
    } catch (e) {
      print('Error: $e');
    }
    if (message != null && message.isNotEmpty) throw Exception(message);
    throw Exception('Tải danh sách cửa hàng thất bại.');
  }
}

class StoreSelectionScreen extends StatefulWidget {
  final bool canBack;

  const StoreSelectionScreen({Key key, this.canBack = false}) : super(key: key);

  @override
  _StoreSelectScreenState createState() => _StoreSelectScreenState();
}

class _StoreSelectScreenState extends State<StoreSelectionScreen>
    with SingleTickerProviderStateMixin {
  Future<List<Store>> stores;
  bool searchInputVisible;
  IconData actionIcon = Icons.search;
  String keyword;

  @override
  void initState() {
    this.searchInputVisible = false;
    super.initState();
    stores = getAll();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: BackAppBar(
          showBackButton: widget.canBack,
          right: <Widget>[
            CupertinoButton(
              pressedOpacity: 1,
              child: Icon(
                this.searchInputVisible ? Icons.close : Icons.search,
                size: 24,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                this.setState(() {
                  searchInputVisible = !searchInputVisible;
                  keyword = null;
                });
              },
            )
          ],
          title: 'Mời chọn cửa hàng',
          showShoppingCart: false,
          bottom: this.searchInputVisible
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        keyword = value;
                      });
                    },
                    style: TextStyle(color: colorScheme.onPrimary),
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: 'Nhập từ khóa...',
                      hintStyle:
                          TextStyle(color: colorScheme.onPrimary,),
                    ),
                  ),
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Container(),
                ),
        ),
        body: Center(
          child: FutureBuilder<List<Store>>(
            future: stores,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildSearchList(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget _buildSearchList(List<Store> storeList) {
    List<Store> searchList = [];
    if (keyword == null || keyword.isEmpty)
      searchList = storeList;
    else {
      searchList = storeList
          .where((e) => e.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: searchList.length,
      itemBuilder: (BuildContext context, int index) {
        //
        if (index == 0)
          return Column(
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              StoreItem(
                store: searchList[index],
              ),
            ],
          );
        return StoreItem(
          store: searchList[index],
        );
      },
    );
  }
}

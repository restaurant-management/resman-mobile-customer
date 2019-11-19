import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/constants/textStyles.dart';
import 'package:resman_mobile_customer/src/screens/storeSelectionScreen/storeItem.dart';
import 'storeItem.dart';

class Store {
  final int id;
  final String name;
  final String logo;
  final String address;
  final String description;
  final String hotline;
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
    this.openTime,
    this.closeTime,
    this.rating,
  });
}

class StoreSelectionScreen extends StatefulWidget {
  @override
  _StoreSelectScreenState createState() => _StoreSelectScreenState();
}

class _StoreSelectScreenState extends State<StoreSelectionScreen>
    with SingleTickerProviderStateMixin {
  List<Store> stores = [

    Store(
      id: 123,
      name: 'ABC',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 234,
      name: 'XYZ',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 345,
      name: 'UIT',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 456,
      name: 'HPX',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 567,
      name: 'AGK',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
    Store(
      id: 678,
      name: 'UKH',
      logo: 'https://www.abcrestaurants.com/images/1000x0/kerst-25-dec.jpg',
      address: 'Q9',
      description: 'cơm ngon vl',
      hotline: '19000000',
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      rating: 4.9,
    ),
  ];

  bool searchInputVisible;
  IconData actionIcon = Icons.search;
  String keyword;

  @override
  void initState() {
    this.searchInputVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          CupertinoButton(
            child: Icon(
              this.searchInputVisible ? Icons.close : Icons.search,
              size: 24,
              color: colorScheme.primary,
            ),
            onPressed: () {
              this.setState(() {
                searchInputVisible = !searchInputVisible;
                keyword = null;
              });
            },
          )
        ],
        backgroundColor: colorScheme.onPrimary,
        title: Text(
          'Mời chọn nhà hàng!',
          style: TextStyles.h5Headline.merge(
            TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        bottom: this.searchInputVisible
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      keyword = value;
                    });
                  },
                  style: TextStyle(color: colorScheme.primary),
                  autofocus: true,
                  decoration: InputDecoration(
//              suffixIcon: Icon(
//                Icons.search,
//                color: colorScheme.primary,
//              ),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: 'Nhập từ khóa...',
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(88, 37, 176, 0.8)),
                  ),
                ),
              )
            : PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: Container(),
              ),
        centerTitle: true,
        elevation: 3,
      ),
      body: _buildSearchList(stores),
    );
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

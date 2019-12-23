import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/dailyDishBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/dailyDishBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/dailyDishBloc/state.dart';
import 'package:resman_mobile_customer/src/models/dailyDish.dart';
import 'package:resman_mobile_customer/src/widgets/dishList/toDayDishesList.dart';
import 'package:resman_mobile_customer/src/widgets/loadingIndicator.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  String keyword;
  final DailyDishBloc _dailyDishBloc = DailyDishBloc();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: primaryColor,
        title: TextField(
          onChanged: (value) {
            setState(() {
              keyword = value;
            });
          },
          style: TextStyle(color: colorScheme.onPrimary),
          autofocus: true,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: colorScheme.onPrimary,
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Nhập tên món ăn ...',
            hintStyle: TextStyle(color: colorScheme.onPrimary),
          ),
        ),
      ),
      body: BlocBuilder(
        bloc: _dailyDishBloc,
        builder: (BuildContext context, state) {
          if (state is DailyDishFetching) return LoadingIndicator();
          if (state is DailyDishFetched) {
            if (state.listDailyDish.length == 0) {
              return Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Text('Không có món nào cả!'),
                        FlatButton(
                          child: Text('Tải lại'),
                          onPressed: () {
                            _dailyDishBloc.dispatch(FetchDailyDish());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return _buildSearchList(state.listDailyDish);
          }
          if (state is DailyDishFetchFailure) {
            return Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      Text(state.error.split(':')[1]),
                      FlatButton(
                        child: Text('Tải lại'),
                        onPressed: () {
                          _dailyDishBloc.dispatch(FetchDailyDish());
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  /// Tham số truyền vào là danh sách tất cả món ăn hằng ngày
  Widget _buildSearchList(List<DailyDish> dailyDishes) {
    List<DailyDish> searchList = [];
    if (keyword == null || keyword.isEmpty)
      searchList = dailyDishes;
    else {
      searchList = dailyDishes
          .where(
              (e) => e.dish.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    return TodayDishesList(
      listDailyDish: searchList,
    );
  }
}

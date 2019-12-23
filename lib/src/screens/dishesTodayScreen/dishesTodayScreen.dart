import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:resman_mobile_customer/src/blocs/dailyDishBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/dailyDishBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/dailyDishBloc/state.dart';
import 'package:resman_mobile_customer/src/widgets/dishList/toDayDishesList.dart';
import 'package:resman_mobile_customer/src/widgets/loadingIndicator.dart';

import '../../widgets/AppBars/mainAppBar.dart';
import '../../widgets/cartButton/secondaryCartButton.dart';
import '../../widgets/drawerScaffold.dart';

class DishesTodayScreen extends StatefulWidget {
  @override
  _DishesTodayScreenState createState() => _DishesTodayScreenState();
}

class _DishesTodayScreenState extends State<DishesTodayScreen> {
  final DailyDishBloc _dailyDishBloc = DailyDishBloc();
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      appBar: MainAppBar(),
      floatingActionButton: SecondaryCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(children: <Widget>[
        BlocBuilder(
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
              return SmartRefresher(
                enablePullDown: true,
                header: defaultTargetPlatform == TargetPlatform.iOS
                    ? WaterDropHeader()
                    : WaterDropMaterialHeader(),
                controller: _refreshController,
                onRefresh: () {
                  _dailyDishBloc.dispatch(FetchDailyDish());
                },
                child: TodayDishesList(
                  listDailyDish: state.listDailyDish,
                ),
              );
            }
            if (state is DailyDishFetchFailure) {
              return Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Text(state.error),
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
        Align(
          heightFactor: 60,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
              colors: <Color>[
                Theme.of(context).primaryColor.withAlpha(180),
                Theme.of(context).primaryColor.withAlpha(80),
                Theme.of(context).primaryColor.withAlpha(0),
              ],
              stops: [0.1, 0.7, 1.0],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
            height: 60.0,
          ),
        )
      ]),
    );
  }

  @override
  void dispose(){
    _refreshController.dispose();
    super.dispose();
  }
}

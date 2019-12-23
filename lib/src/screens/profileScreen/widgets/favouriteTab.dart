import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/favouriteBloc.dart';
import 'package:resman_mobile_customer/src/blocs/favouriteDishesBloc.dart';
import 'package:resman_mobile_customer/src/widgets/dishList/dishesList.dart';
import 'package:resman_mobile_customer/src/widgets/errorIndicator.dart';
import 'package:resman_mobile_customer/src/widgets/loadingIndicator.dart';

class FavouriteTab extends StatelessWidget {
  final FavouriteDishesBloc _favouriteDishesBloc = FavouriteDishesBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _favouriteDishesBloc,
      builder: (context, state) {
        if (state is FavouriteDishesFetchFailure) {
          return ErrorIndicator(
            message: state.error,
            reloadOnPressed: () {
              _favouriteDishesBloc.dispatch(FetchFavouriteDishes());
            },
          );
        } else if (state is FavouriteDishesFetchSuccess) {
          return DishesList(
            listDish: state.favouriteDishes,
          );
        }
        return LoadingIndicator();
      },
    );
  }
}

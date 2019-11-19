import 'package:bloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartItemBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/cartItemBloc/state.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  final Repository _repository = Repository();

  @override
  CartItemState get initialState => CartItemInitialize();

  @override
  Stream<CartItemState> mapEventToState(CartItemEvent event) async* {
    if (event is FetchCartItemDetail) {
      var dishesToday = _repository.dailyDishes;
      var result = dishesToday.firstWhere(
              (dish) => dish.dish.dishId == event.cartDish.dishId,
          orElse: () => null);
      if (result == null) {
        yield CartItemToFetchDetailNotSellToDay(event.cartDish);
      } else {
        yield CartItemFetchedCartDishDetail(result);
      }
    }
  }

}
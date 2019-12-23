import 'package:bloc/bloc.dart';
import 'package:resman_mobile_customer/src/models/discountCode.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';

class ValidateDiscountCodeBloc
    extends Bloc<ValidateDiscountCodeEvent, ValidateDiscountCodeState> {
  @override
  ValidateDiscountCodeState get initialState =>
      ValidateDiscountCodeInitialize();

  @override
  Stream<ValidateDiscountCodeState> mapEventToState(
      ValidateDiscountCodeEvent event) async* {
    if (event is ValidateDiscountCode) {
      yield ValidateDiscountCodeLoading();
      try {
        yield ValidateDiscountCodeSuccess(
            await Repository().getDiscountCode(event.code));
      } catch (e) {
        yield ValidateDiscountCodeFailure(e.toString());
      }
    }
  }
}

// ============ EVENT ============//

abstract class ValidateDiscountCodeEvent {}

class ValidateDiscountCode extends ValidateDiscountCodeEvent {
  final String code;

  ValidateDiscountCode(this.code);
  @override
  String toString() => 'ValidateDiscountCode ($code)';
}

// ============ STATE ============//

abstract class ValidateDiscountCodeState {}

class ValidateDiscountCodeInitialize extends ValidateDiscountCodeState {
  @override
  String toString() => 'ValidateDiscountCodeInitialize';
}

class ValidateDiscountCodeLoading extends ValidateDiscountCodeState {
  @override
  String toString() => 'ValidateDiscountCodeLoading';
}

class ValidateDiscountCodeSuccess extends ValidateDiscountCodeState {
  final DiscountCode code;

  ValidateDiscountCodeSuccess(this.code);
  @override
  String toString() => 'ValidateDiscountCodeSuccess (${code.code})';
}

class ValidateDiscountCodeFailure extends ValidateDiscountCodeState {
  final String message;

  ValidateDiscountCodeFailure(this.message);
  @override
  String toString() => 'ValidateDiscountCodeInitialize ($message)';
}

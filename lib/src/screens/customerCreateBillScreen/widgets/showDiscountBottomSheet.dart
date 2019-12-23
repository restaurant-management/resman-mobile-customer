import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/ValidateDiscountCodeBloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/cartBloc/event.dart';
import 'package:resman_mobile_customer/src/utils/gradientColor.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:toast/toast.dart';

showInputDiscountBottomSheet(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final ValidateDiscountCodeBloc validateDiscountCodeBloc =
      ValidateDiscountCodeBloc();

  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    ),
    context: context,
    builder: (context) {
      var colorScheme = Theme.of(context).colorScheme;
      return Form(
        key: formKey,
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: <Widget>[
                Text(
                  'Mã giảm giá',
                  style: TextStyles.h2Bold
                      .merge(TextStyle(color: colorScheme.onBackground)),
                ),
                Center(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Nhập mã tại đây...',
                      hintStyle: TextStyles.h5
                          .merge(TextStyle(color: colorScheme.onSurface)),
                    ),
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Không được để trống trường này';
                      }
                      if (value.length > 10) {
                        return 'Giá trị nhập vào tối đa 10 ký tự';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: GradientColor.of(context).primaryGradient,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        BlocListener(
                          bloc: validateDiscountCodeBloc,
                          listener: (context, state) {
                            if (state is ValidateDiscountCodeFailure) {
                              Toast.show(state.message, context);
                            }
                            if (state is ValidateDiscountCodeSuccess) {
                              CartBloc()
                                  .dispatch(ChangeDiscountInCart(state.code));
                              validateDiscountCodeBloc.dispose();
                              Navigator.pop(context);
                              Toast.show('Thêm thành công', context);
                            }
                          },
                          child: BlocBuilder(
                            bloc: validateDiscountCodeBloc,
                            builder: (context, state) {
                              return CupertinoButton(
                                disabledColor: colorScheme.onSurface,
                                child: SizedBox(
                                  child: state is ValidateDiscountCodeLoading
                                      ? SizedBox(
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    colorScheme.onPrimary),
                                          ),
                                        )
                                      : Text(
                                          'Lưu',
                                          style: TextStyles.h4.merge(TextStyle(
                                              color: colorScheme.surface)),
                                        ),
                                  height: 20,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 100),
                                minSize: 0,
                                onPressed: state is ValidateDiscountCodeLoading
                                    ? null
                                    : () {
                                        if (formKey.currentState.validate()) {
                                          FocusScope.of(context).unfocus();
                                          validateDiscountCodeBloc.dispatch(
                                              ValidateDiscountCode(
                                                  controller.text));
                                        }
                                      },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

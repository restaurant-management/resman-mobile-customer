import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resman_mobile_customer/src/blocs/authenticationBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/authenticationBloc/state.dart';
import 'package:resman_mobile_customer/src/blocs/loginBloc/bloc.dart';
import 'package:resman_mobile_customer/src/blocs/loginBloc/event.dart';
import 'package:resman_mobile_customer/src/blocs/loginBloc/state.dart';
import 'package:resman_mobile_customer/src/screens/loginScreen/loginScreen.dart';
import 'package:resman_mobile_customer/src/utils/gradientColor.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

void showLoginAlert(BuildContext context, AuthenticationBloc authenticationBloc,
    LoginBloc loginBloc) {
  if (authenticationBloc.currentState is AuthenticationAuthenticated) {
    return;
  }

  final colorScheme = Theme.of(context).colorScheme;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Alert(
    closeFunction: () {},
    context: context,
    title: "Vui lòng đăng nhập",
    style: AlertStyle(
      titleStyle: TextStyles.h2Bold.merge(
        TextStyle(color: colorScheme.primary),
      ),
      isCloseButton: false,
      animationType: AnimationType.grow,
      buttonAreaPadding: EdgeInsets.all(10),
    ),
    content: Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: usernameController,
            validator: (value) {
              if (value.isEmpty)
                return 'Vui lòng nhập thông tin vào trường này!';
              return null;
            },
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'Tên đăng nhập hoặc email',
              labelStyle: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            validator: (value) {
              if (value.isEmpty)
                return 'Vui lòng nhập thông tin vào trường này!';
              return null;
            },
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Mật khẩu',
              labelStyle: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          SizedBox(height: 20),
          BlocListener(
            bloc: loginBloc,
            listener: (listenContext, state) {
              if (state is LoginFailure) {
                Toast.show(state.error, context,
                    gravity: Toast.BOTTOM, duration: 2);
              }
            },
            child: BlocBuilder(
              bloc: loginBloc,
              builder: (blocContext, state) {
                return DialogButton(
                    gradient: GradientColor.of(context).primaryGradient,
                    onPressed: state is LoginLoading
                        ? null
                        : () {
                            FocusScope.of(blocContext).unfocus();
                            if (formKey.currentState.validate()) {
                              loginBloc.dispatch(LoginButtonPressed(
                                usernameOrEmail: usernameController.text,
                                password: passwordController.text,
                              ));
                              authenticationBloc.state.listen((state) {
                                if (state is AuthenticationAuthenticated) {
                                  Navigator.pop(context);
                                  Toast.show('Đăng nhập thành công.', context,
                                      gravity: Toast.BOTTOM, duration: 2);
                                }
                              });
                            }
                          },
                    child: state is LoginLoading
                        ? SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onPrimary),
                            ),
                          )
                        : Text(
                            "Đăng nhập",
                            style: TextStyles.h3,
                          ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CupertinoButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(
                      openRegister: true,
                    ),
                  ),
                );
              },
              minSize: 0,
              padding: EdgeInsets.all(0),
              child: Text(
                'Đăng ký',
                style: TextStyles.h4
                    .merge(TextStyle(color: colorScheme.onSurface)),
              ),
            ),
          )
        ],
      ),
    ),
    buttons: [],
  ).show();
}

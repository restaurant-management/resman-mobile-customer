import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resman_mobile_customer/src/utils/textStyles.dart';

class LoginTextInput extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final VoidCallback onEditingComplete;

  LoginTextInput(
      {this.hint,
      this.obscure,
      this.icon,
      this.validator,
      this.controller,
      this.keyboardType,
      this.onEditingComplete});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: Colors.white,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: hint,
        hintStyle: TextStyles.h4
            .merge(TextStyle(color: Theme.of(context).hintColor)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}

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
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: colorScheme.onPrimary,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(color: colorScheme.onPrimary),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: colorScheme.onPrimary,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: hint,
        hintStyle:
            TextStyles.h4.merge(TextStyle(color: colorScheme.onPrimary)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: colorScheme.onPrimary, width: 1),
          borderRadius: BorderRadius.circular(32),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utils/formatters.dart';

class OperationPageTextField extends StatelessWidget {
  final bool autofocus;

  final String? Function(String? value)? validate;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final Key formKey;

  final String hintText;
  final String labelText;
  final String suffixText;
  final String counterText;

  final bool onlyInteger;
  final int decimals;

  final TextEditingController controller;

  const OperationPageTextField({
    this.hintText = '0',
    this.autofocus = false,
    this.onlyInteger = false,
    this.validate,
    this.onChanged,
    this.onTap,
    required this.formKey,
    required this.labelText,
    this.suffixText = '',
    this.counterText = '',
    required this.decimals,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(
          height: 100,
          width: context.width - 40,
          child: Form(
            key: formKey,
            child: TextFormField(
              validator: validate,
              controller: controller,
              maxLength: 12,
              style: const TextStyle(fontSize: 25),
              autofocus: autofocus,
              decoration: InputDecoration(
                hintText: hintText,
                suffixText: suffixText,
                suffixStyle: context.textTheme.displaySmall?.copyWith(fontSize: 19),
                counterText: counterText,
                border: InputBorder.none,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              maxLines: 1,
              inputFormatters: [
                onlyInteger || (decimals == 0) ? FilteringTextInputFormatter.digitsOnly : DecimalTextInputFormatter(decimalRange: decimals),
              ],
              onChanged: onChanged,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

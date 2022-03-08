import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final NumberFormat _doubleFormatter = NumberFormat('#,##0.00');
final NumberFormat _intFormatter = NumberFormat('#,###');

extension CustomNumUtils on num {
  num roundToDecimals(int decimals) => num.parse(toStringAsFixed(decimals));

  num roundZeros() => num.parse(toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), ''));

  int countDecimals() {
    List<String> parts = toString().split('.');
    if (parts.length == 1) return 0;
    return parts.last.length;
  }

  String doubleFormat({int? decimals}) {
    num number = decimals == null ? this : roundToDecimals(decimals);
    return _doubleFormatter.format(number).replaceAll(',', ' ');
  }

  String intFormat() {
    return _intFormatter.format(this).replaceAll(',', ' ');
  }

  String currencyFormat({String? locale, String? symbol, int? decimals}) {
    return NumberFormat.currency(decimalDigits: decimals, locale: locale ?? Get.deviceLocale?.languageCode, symbol: symbol).format(this);
  }

  String percentFormat({String? locale, int? decimals}) {
    return NumberFormat.decimalPercentPattern(locale: locale ?? Get.deviceLocale?.languageCode, decimalDigits: decimals).format(this);
  }

  String compactFormat({String? locale}) {
    return NumberFormat.compact(locale: locale ?? Get.deviceLocale?.languageCode).format(this);
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange}) : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      // не более одной точки
      // if ('.'.allMatches(value).length > 1) {
      //   truncated = oldValue.text;
      //   newSelection = oldValue.selection;
      // } // не более decimalRange знаков после точки
      if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      } else if (value == '00') {
        truncated = "0";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      } else if ((value.isNotEmpty) && (double.tryParse(value) == null)) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

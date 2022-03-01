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

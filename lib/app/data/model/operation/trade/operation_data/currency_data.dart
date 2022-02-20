import 'dart:convert';

import '../../../../enums/common_currencies.dart';
import '../../../../enums/market_types.dart';
import '../../trade/trade_operation_data.dart';

// TODO: implement currency model
class CurrencyTradeOperationData extends TradeOperationData {
  final CommonCurrency buyCurrency;
  final CommonCurrency sellCurrency;
  final num amount;
  final num price;
  final num fee;

  CurrencyTradeOperationData({
    required String note,
    required this.buyCurrency,
    required this.sellCurrency,
    required this.amount,
    required this.price,
    required this.fee,
  }) : super(
          assetType: AssetType.currencies,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'assetType': assetType.name,
      'buyCurrency': buyCurrency,
      'sellCurrency': sellCurrency,
      'amount': amount,
      'price': price,
      'fee': fee,
      'note': note,
    };
  }

  factory CurrencyTradeOperationData.fromMap(Map<String, dynamic> map) {
    return CurrencyTradeOperationData(
      buyCurrency: CommonCurrency.values.byName(map['buyCurrency']),
      sellCurrency: CommonCurrency.values.byName(map['sellCurrency']),
      amount: map['amount'],
      price: map['price'],
      fee: map['fee'],
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrencyTradeOperationData.fromJson(String source) => CurrencyTradeOperationData.fromMap(json.decode(source));
}

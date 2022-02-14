import 'dart:convert';

import '../../../../enums/market_types.dart';
import '../../../asset/crypto_model.dart';
import '../../trade/trade_operation_data.dart';

class CryptoTradeOperationData extends TradeOperationData {
  // model
  final CryptoModel base;
  final CryptoModel quote;

  // operation details
  final num amount;
  final num price;
  final num fee;

  CryptoTradeOperationData({
    required String note,
    required this.base,
    required this.quote,
    required this.amount,
    required this.price,
    required this.fee,
  }) : super(
          marketType: MarketType.crypto,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'marketType': marketType.name,
      'base': base.toMap(),
      'quote': quote.toMap(),
      'amount': amount,
      'price': price,
      'fee': fee,
      'note': note,
    };
  }

  factory CryptoTradeOperationData.fromMap(Map<String, dynamic> map) {
    return CryptoTradeOperationData(
      base: CryptoModel.fromMap(map['base']),
      quote: CryptoModel.fromMap(map['quote']),
      amount: map['amount'],
      price: map['price'],
      fee: map['fee'],
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CryptoTradeOperationData.fromJson(String source) => CryptoTradeOperationData.fromMap(json.decode(source));
}

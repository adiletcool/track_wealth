import 'dart:convert';

import '../../../../enums/common_currencies.dart';
import '../../../../enums/market_types.dart';
import '../../../asset/moex/stock_model.dart';
import '../../trade/trade_operation_data.dart';

class StockTradeOperationData extends TradeOperationData {
  // model
  final SearchStockModel stock;

  // operation details
  final CommonCurrency currency;
  final num amount;
  final num price;
  final num fee;

  StockTradeOperationData({
    required String note,
    required this.stock,
    required this.currency,
    required this.amount,
    required this.price,
    required this.fee,
  }) : super(
          assetType: AssetType.stocks,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'assetType': assetType.name,
      'stock': stock.toMap(),
      'currency': currency,
      'amount': amount,
      'price': price,
      'fee': fee,
      'note': 'note',
    };
  }

  factory StockTradeOperationData.fromMap(Map<String, dynamic> map) {
    return StockTradeOperationData(
      stock: SearchStockModel.fromMap(map['stock']),
      currency: CommonCurrency.values.byName(map['currency']),
      amount: map['amount'],
      price: map['price'],
      fee: map['fee'],
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StockTradeOperationData.fromJson(String source) => StockTradeOperationData.fromMap(json.decode(source));
}

import '../../../enums/market_types.dart';
import '../operation_model.dart';
import 'operation_data/bond_data.dart';
import 'operation_data/crypto_data.dart';
import 'operation_data/currency_data.dart';
import 'operation_data/stock_data.dart';

abstract class TradeOperationData extends OperationData {
  final MarketType marketType;

  TradeOperationData({
    required String note,
    required this.marketType,
  }) : super(note: note);

  factory TradeOperationData.fromMap(Map<String, dynamic> map) {
    switch (MarketType.values.byName(map['marketType'])) {
      case MarketType.stocks:
        return StockTradeOperationData.fromMap(map);
      case MarketType.currencies:
        return CurrencyTradeOperationData.fromMap(map);
      case MarketType.crypto:
        return CryptoTradeOperationData.fromMap(map);
      case MarketType.bonds:
        return BondTradeOperationData.fromMap(map);
      case MarketType.starred:
        throw 'Cannot add operation with `Starred` market type';
    }
  }
}

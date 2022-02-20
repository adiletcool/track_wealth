import '../../../enums/market_types.dart';
import '../operation_model.dart';
import 'operation_data/bond_data.dart';
import 'operation_data/crypto_data.dart';
import 'operation_data/currency_data.dart';
import 'operation_data/stock_data.dart';

abstract class TradeOperationData extends OperationData {
  final AssetType assetType;

  TradeOperationData({
    required String note,
    required this.assetType,
  }) : super(note: note);

  factory TradeOperationData.fromMap(Map<String, dynamic> map) {
    switch (AssetType.values.byName(map['assetType'])) {
      case AssetType.stocks:
        return StockTradeOperationData.fromMap(map);
      case AssetType.currencies:
        return CurrencyTradeOperationData.fromMap(map);
      case AssetType.crypto:
        return CryptoTradeOperationData.fromMap(map);
      case AssetType.bonds:
        return BondTradeOperationData.fromMap(map);
    }
  }
}

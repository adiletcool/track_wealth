import 'dart:convert';

import '../../../../enums/common_currencies.dart';
import '../../../../enums/market_types.dart';
import '../trade_operation_data.dart';

// TODO: implement BondModel
// * https://iss.moex.com/iss/engines/stock/markets/bonds/boards/TQOB/securities/SU24020RMFS8.jsonp?callback=iss_jsonp_487382b8d6ae0d65286082e6ecd52667f50c8d58&iss.meta=off&iss.only=securities&lang=ru&_=1643927592952
class BondTradeOperationData extends TradeOperationData {
  // Main
  final String secId;
  final String boardId; // 'TQOB'
  final String shortName;
  final String fullName;
  final String bondType; // e.g. ОФЗ
  final String issueDate; // Дата начала торгов
  final String maturityDate; // Дата погашения
  final String offerDate; // Дата Оферты
  final String status; // Статус: A...
  final CommonCurrency currency; // Валюта номинала
  final num issueSize; // Количество ценных бумаг в обращении
  final num listLevel; // Уровень листинга

  // Coupons
  final num couponValue;
  final String nextCoupon; // Дата выплаты следующего купона
  final num couponPeriod; // 91 means 364 / 91 = 4 coupons per year
  final num couponPercent; // Ставка купона, %

  // Lot
  final num lotSize; // Размер лота, ц.б.
  final num lotValue; // Номинальная стоимость лота, в валюте номинала

  // Buyback

  // Standard
  final num amount;
  final num price;

  BondTradeOperationData({
    required String note,
    required this.secId,
    required this.boardId,
    required this.shortName,
    required this.fullName,
    required this.bondType,
    required this.issueDate,
    required this.maturityDate,
    required this.offerDate,
    required this.status,
    required this.currency,
    required this.issueSize,
    required this.listLevel,
    required this.couponValue,
    required this.nextCoupon,
    required this.couponPeriod,
    required this.couponPercent,
    required this.lotSize,
    required this.lotValue,
    required this.amount,
    required this.price,
  }) : super(marketType: MarketType.bonds, note: note);

  @override
  Map<String, dynamic> toMap() {
    return {
      'marketType': marketType.name,
      'secId': secId,
      'boardId': boardId,
      'shortName': shortName,
      'fullName': fullName,
      'bondType': bondType,
      'issueDate': issueDate,
      'maturityDate': maturityDate,
      'offerDate': offerDate,
      'status': status,
      'currency': currency.name,
      'issueSize': issueSize,
      'listLevel': listLevel,
      'couponPeriod': couponPeriod,
      'couponValue': couponValue,
      'nextCoupon': nextCoupon,
      'couponPercent': couponPercent,
      'lotSize': lotSize,
      'lotValue': lotValue,
      'amount': amount,
      'price': price,
      'note': note,
    };
  }

  factory BondTradeOperationData.fromMap(Map<String, dynamic> map) {
    return BondTradeOperationData(
      secId: map['secId'],
      boardId: map['boardId'],
      shortName: map['shortName'],
      fullName: map['fullName'],
      bondType: map['bondType'],
      issueDate: map['issueDate'],
      maturityDate: map['maturityDate'],
      offerDate: map['offerDate'],
      status: map['status'],
      currency: CommonCurrency.values.byName(map['currency']),
      issueSize: map['issueSize'],
      listLevel: map['listLevel'],
      couponPeriod: map['couponPeriod'],
      couponValue: map['couponValue'],
      nextCoupon: map['nextCoupon'],
      couponPercent: map['couponPercent'],
      lotSize: map['lotSize'],
      lotValue: map['lotValue'],
      amount: map['amount'],
      price: map['price'],
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BondTradeOperationData.fromJson(String source) => BondTradeOperationData.fromMap(json.decode(source));
}

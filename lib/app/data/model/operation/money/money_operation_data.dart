import '../../../enums/common_currencies.dart';
import '../operation_model.dart';

class MoneyOperationData extends OperationData {
  final num amount;
  final num fee;
  final CommonCurrency currency;

  MoneyOperationData({
    required String note,
    required this.amount,
    required this.fee,
    required this.currency,
  }) : super(note: note);

  @override
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
      'fee': fee,
      'note': note,
    };
  }

  factory MoneyOperationData.fromMap(Map<String, dynamic> map) {
    return MoneyOperationData(
      note: map['note'],
      amount: map['amount'],
      fee: map['fee'],
      currency: CommonCurrency.values.byName(map['currency']),
    );
  }
}

class DividendOperationData extends MoneyOperationData {
  final String boardId;
  final String secId;
  final String shortName;

  DividendOperationData({
    required num amount,
    required num fee,
    required CommonCurrency currency,
    required String note,
    required this.boardId,
    required this.secId,
    required this.shortName,
  }) : super(
          amount: amount,
          currency: currency,
          fee: fee,
          note: note,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'boardId': boardId,
      'secId': secId,
      'shortName': shortName,
      'amount': amount,
      'currency': currency,
      'fee': fee,
      'note': note,
    };
  }

  factory DividendOperationData.fromMap(Map<String, dynamic> map) {
    return DividendOperationData(
      boardId: map['boardId'],
      secId: map['secId'],
      shortName: map['shortName'],
      amount: map['amount'],
      currency: CommonCurrency.values.byName(map['currency']),
      note: map['note'],
      fee: map['fee'],
    );
  }
}

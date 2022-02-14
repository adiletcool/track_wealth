import '../../enums/operation.dart';
import 'money/money_operation_model.dart';
import 'trade/trade_operation_model.dart';

abstract class Operation {
  final OperationType operationType;
  final String date;
  final OperationData data;

  Operation({
    required this.operationType,
    required this.date,
    required this.data,
  });

  Map<String, dynamic> toMap();

  factory Operation.fromMap(Map<String, dynamic> map) {
    switch (OperationType.values.byName(map['operationType'])) {
      case OperationType.trade:
        return TradeOperation.fromMap(map);
      case OperationType.money:
        return MoneyOperation.fromMap(map);
    }
  }
}

abstract class OperationData {
  final String note;

  OperationData({required this.note});

  Map<String, dynamic> toMap();
}

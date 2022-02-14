import '../../../enums/operation.dart';
import '../operation_model.dart';
import 'money_operation_data.dart';

class MoneyOperation extends Operation {
  final MoneyAction action;

  MoneyOperation({
    required MoneyOperationData data,
    required String date,
    required this.action,
  }) : super(
          operationType: OperationType.money,
          date: date,
          data: data,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'operationType': operationType.name,
      'action': action,
      'date': date,
      'data': data.toMap(),
    };
  }

  factory MoneyOperation.fromMap(Map<String, dynamic> map) {
    MoneyAction moneyAction = MoneyAction.values.byName(map['action']);
    MoneyOperationData moneyOperationData;

    switch (moneyAction) {
      case MoneyAction.deposit:
      case MoneyAction.withdrawal:
      case MoneyAction.revenue:
      case MoneyAction.expense:
        moneyOperationData = MoneyOperationData.fromMap(map['data']);
        break;

      case MoneyAction.dividends:
        moneyOperationData = DividendOperationData.fromMap(map['data']);
        break;
    }

    return MoneyOperation(
      action: moneyAction,
      date: map['date'],
      data: moneyOperationData,
    );
  }
}

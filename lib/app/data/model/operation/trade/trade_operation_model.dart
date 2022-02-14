import '../../../enums/operation.dart';
import '../operation_model.dart';
import 'trade_operation_data.dart';

class TradeOperation extends Operation {
  final TradeAction action;

  TradeOperation({
    required TradeOperationData data,
    required String date,
    required this.action,
  }) : super(
          operationType: OperationType.trade,
          date: date,
          data: data,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'operationType': operationType.name,
      'action': action.name,
      'date': date,
      'data': data.toMap(),
    };
  }

  factory TradeOperation.fromMap(Map<String, dynamic> map) {
    return TradeOperation(
      action: TradeAction.values.byName(map['action']),
      date: map['date'],
      data: TradeOperationData.fromMap(map['data']),
    );
  }
}

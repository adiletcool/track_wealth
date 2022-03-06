import 'package:collection/collection.dart';

class OhlcvModel {
  final int timestamp;
  final num open;
  final num high;
  final num low;
  final num close;
  final num volume;

  OhlcvModel({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}

extension ResampleChart on Iterable<OhlcvModel> {
  List<OhlcvModel> resample({required int combineBy}) {
    List<List<OhlcvModel>> chunks = [];

    for (var i = 0; i < length; i += combineBy) {
      chunks.add(toList().sublist(i, i + combineBy > length ? length : i + combineBy));
    }

    List<OhlcvModel> result = List.generate(chunks.length, (i) {
      List<OhlcvModel> chunk = chunks.elementAt(i);

      int timestamp = chunk.first.timestamp;
      num open = chunk.first.open;
      num high = chunk.map((model) => model.high).max;
      num low = chunk.map((model) => model.low).min;
      num close = chunk.last.close;
      num volume = chunk.map((model) => model.volume).sum;

      return OhlcvModel(timestamp: timestamp, open: open, high: high, low: low, close: close, volume: volume);
    });

    return result;
  }
}

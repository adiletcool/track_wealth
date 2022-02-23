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

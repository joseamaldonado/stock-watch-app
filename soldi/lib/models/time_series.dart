class TimeSeries {
  final double open;
  final double high;
  final double low;
  final double close;
  final DateTime date;

  TimeSeries({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.date
  });

  @override
  String toString() {
    return 'TimeSeries(open: $open, high: $high, low: $low, close: $close, date: $date)';
  }
}

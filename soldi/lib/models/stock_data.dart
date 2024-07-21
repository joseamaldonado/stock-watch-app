class StockData {
  final double open;
  final double high;
  final double low;
  final double close;
  final DateTime date;

  StockData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.date
  });

  @override
  String toString() {
    return 'StockData(open: $open, high: $high, low: $low, close: $close, date: $date)';
  }
}

class MarketDay {
  final String date;
  final double open;
  final double close;
  final double high;
  final double low;
  final int volume;

  MarketDay(
      {
      required this.date,
      required this.open,
      required this.close,
      required this.high,
      required this.low,
      required this.volume});
}

import 'package:flutter/material.dart';

class Stock {
  final String symbol;
  final double currentPrice;
  final double todaysOpen;
  late final double percentChange =
      (currentPrice - todaysOpen) / todaysOpen * 100;
  late String priceInfo =
      "\$${currentPrice.toStringAsFixed(2)} ${percentChange.toStringAsFixed(2)}%";

  Stock({
    required this.symbol,
    required this.currentPrice,
    required this.todaysOpen,
  });
}

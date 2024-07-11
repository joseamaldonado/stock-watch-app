import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soldi/models/market_day.dart';
import 'dart:convert';

class WatchPage extends StatefulWidget {
  const WatchPage({super.key});

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  void initState() {
    super.initState();
    getStockDataDaily('IBM');
  }

  List<MarketDay> days = [];

  Future<void> getStockDataDaily(String symbol) async {
    var response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=' +
            symbol +
            '&apikey=WAK9NBRKX4F0XIKW'));
    var jsonData = jsonDecode(response.body);
    (jsonData['Time Series (Daily)'] as Map<String, dynamic>)
        .forEach((date, eachDay) {
      final marketDay = MarketDay(
        date: date,
        open: double.parse(eachDay['1. open']),
        close: double.parse(eachDay['4. close']),
        high: double.parse(eachDay['2. high']),
        low: double.parse(eachDay['3. low']),
        volume: int.parse(eachDay['5. volume']),
      );
      days.add(marketDay);
    });

    print(days.length);

    setState(() {
      this.days = days;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

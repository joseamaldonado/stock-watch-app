import 'package:flutter/material.dart';
import 'package:soldi/models/stock.dart';
import 'package:soldi/models/stock_data.dart';
import 'package:soldi/components/candle_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockPage extends StatefulWidget {
  final Stock stock;
  const StockPage({super.key, required this.stock});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<StockData> timeSeries = [];
  String selectedTimeFrame = 'Daily';

  @override
  void initState() {
    super.initState();
    getStockData(widget.stock.symbol, 'Daily');
  }

  Future<void> getStockData(String symbol, String timeFrame) async {
    String key = _getStockDataKey(timeFrame);
    var response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=TIME_SERIES_$timeFrame&symbol=$symbol&apikey=WAK9NBRKX4F0XIKW'));
    var jsonData = jsonDecode(response.body);

    if (jsonData != null && jsonData[key] != null) {
      setState(() {
        timeSeries.clear();
        (jsonData[key] as Map<String, dynamic>).forEach((date, eachData) {
          final data = StockData(
            date: DateTime.parse(date),
            open: double.parse(eachData['1. open']),
            high: double.parse(eachData['2. high']),
            low: double.parse(eachData['3. low']),
            close: double.parse(eachData['4. close']),
          );
          timeSeries.add(data);
        });
      });
    } else {
      _useMockData(symbol, timeFrame);
    }
  }

  String _getStockDataKey(String timeFrame) {
    switch (timeFrame) {
      case 'Daily':
        return 'Time Series (Daily)';
      case 'Weekly':
        return 'Weekly Time Series';
      case 'Monthly':
        return 'Monthly Time Series';
      default:
        return 'Time Series (Daily)'; // Default fallback
    }
  }

  void _useMockData(String symbol, String timeFrame) {
    setState(() {
      timeSeries.clear();
      if (timeFrame == 'Daily') {
        timeSeries.addAll([
          StockData(open: 52, high: 55, low: 50, close: 53, date: DateTime.now().subtract(Duration(days: 5))),
          StockData(open: 53, high: 54, low: 48, close: 52, date: DateTime.now().subtract(Duration(days: 4))),
          StockData(open: 52, high: 60, low: 50, close: 58, date: DateTime.now().subtract(Duration(days: 3))),
          StockData(open: 58, high: 68, low: 58, close: 67, date: DateTime.now().subtract(Duration(days: 2))),
          StockData(open: 67, high: 75, low: 65, close: 74, date: DateTime.now().subtract(Duration(days: 1))),
        ]);
      } else if (timeFrame == 'Weekly') {
        timeSeries.addAll([
          StockData(open: 52, high: 55, low: 50, close: 53, date: DateTime.now().subtract(Duration(days: 7))),
          StockData(open: 53, high: 54, low: 48, close: 52, date: DateTime.now().subtract(Duration(days: 14))),
        ]);
      } else if (timeFrame == 'Monthly') {
        timeSeries.addAll([
          StockData(open: 52, high: 60, low: 48, close: 59, date: DateTime.now().subtract(Duration(days: 30))),
          StockData(open: 59, high: 72, low: 48, close: 67, date: DateTime.now().subtract(Duration(days: 60))),
        ]);
      }
    });
  }

  Widget buildTimeFrameButton(String timeFrame) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedTimeFrame = timeFrame;
          getStockData(widget.stock.symbol, timeFrame);
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: selectedTimeFrame == timeFrame ? Colors.grey : Colors.transparent,
        foregroundColor: selectedTimeFrame == timeFrame ? Colors.white : Colors.black,
      ),
      child: Text(timeFrame),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: const Text('Soldi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.stock.symbol,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                    Text(widget.stock.priceInfo,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: widget.stock.currentPrice >
                                    widget.stock.todaysOpen
                                ? Colors.green
                                : (widget.stock.currentPrice <
                                        widget.stock.todaysOpen)
                                    ? Colors.red
                                    : Colors.black)),
                  ],
                ),
              ),
              // Stock data graph
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CandleChartWidget(timeSeries: timeSeries)),
              ),
              // Change time frame buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTimeFrameButton('Daily'),
                    buildTimeFrameButton('Weekly'),
                    buildTimeFrameButton('Monthly'),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:soldi/models/stock.dart';
import 'package:soldi/models/day.dart';
import 'package:soldi/components/candle_chart.dart';

class StockPage extends StatefulWidget {
  final Stock stock;
  const StockPage({super.key, required this.stock});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<Day> days = [];

  @override
  void initState() {
    super.initState();
    getStockDailyData(widget.stock.symbol);
  }

  Future<void> getStockDailyData(String symbol) async {
    _useMockDailyData(symbol);
    /*
    try {
      var response = await http.get(Uri.parse(
          'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=WAK9NBRKX4F0XIKW'));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(jsonData); // Debug: Print the entire response

        if (jsonData['Global Quote'] != null) {
          var globalQuote = jsonData['Global Quote'] as Map<String, dynamic>;

          setState(() {
            stocks.add(Stock(
              symbol: symbol,
              price: double.parse(globalQuote['05. price']),
              open: double.parse(globalQuote['02. open']),
            ));
          });
        } else {
          print(
              'Global Quote not found in the response'); // Debug: No Global Quote
          _useMockData(symbol); // Use mock data if Global Quote not found
        }
      } else {
        print(
            'Failed to load data. Status code: ${response.statusCode}'); // Debug: Failed request
        _useMockData(symbol); // Use mock data if request failed
      }
    } catch (e) {
      print('Error: $e'); // Debug: Print any errors
      _useMockData(symbol); // Use mock data in case of error
    }
    */
  }

  void _useMockDailyData(String symbol) {
    setState(() {
      days.add(Day( 
          open: 52, // Mock price value
          high: 55, // Mock open value
          low: 50, // Mock price value
          close: 53, // Mock close value
          // volume: 1000 // Mock volume value
          date: DateTime.now().subtract(Duration(days: 5))));
      days.add(Day(
        open: 53, // Mock price value
        high: 54, // Mock open value
        low: 48, // Mock price value
        close: 52, // Mock close value
        // volume: 1000 // Mock volume value
        date: DateTime.now().subtract(Duration(days: 4)),
      ));
      days.add(Day(
        open: 52, // Mock price value
        high: 60, // Mock open value
        low: 50, // Mock price value
        close: 58, // Mock close value
        // volume: 1000 // Mock volume value
        date: DateTime.now().subtract(Duration(days: 3)),
      ));
      days.add(Day(
        open: 58, // Mock price value
        high: 68, // Mock open value
        low: 58, // Mock price value
        close: 67, // Mock close value
        // volume: 1000 // Mock volume value
        date: DateTime.now().subtract(Duration(days: 2)),
      ));
      days.add(Day(
        open: 67, // Mock price value
        high: 75, // Mock open value
        low: 65, // Mock price value
        close: 74, // Mock close value
        // volume: 1000 // Mock volume value
        date: DateTime.now().subtract(Duration(days: 1)),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text(widget.stock.symbol, style: const TextStyle(fontSize: 24)),
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
                    Text('${widget.stock.symbol}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )
                    ),
                    Text("\$${widget.stock.currentPrice.toStringAsFixed(2)}")

                    
                  ],
                ),
              ),
              // Stock data graph (line graph easiest and best)
              Center(child: CandleChartWidget(days: days))
              // Metrics: Intrinsic value, etc...
            ],
          ),
        ));
  }
}

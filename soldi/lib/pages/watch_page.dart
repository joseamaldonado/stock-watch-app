import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soldi/models/stock.dart';
import 'dart:convert';
import 'package:soldi/pages/stock_page.dart';

class WatchPage extends StatefulWidget {
  const WatchPage({super.key});

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  List<Stock> stocks = [];
  late Future<void> stockFuture;

  @override
  void initState() {
    super.initState();
    stockFuture = getStockQuote('NKE');
  }

  Future<void> getStockQuote(String symbol) async {
    _useMockData(symbol);
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

  void _useMockData(String symbol) {
    setState(() {
      stocks.add(Stock(
        symbol: symbol,
        currentPrice: 52, // Mock price value
        todaysOpen: 50, // Mock open value
      ));
    });
  }

  void _showAddStockDialog() {
    TextEditingController symbolCtrl = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Stock'),
            content: TextField(
              controller: symbolCtrl,
              decoration: const InputDecoration(hintText: "Symbol"),
            ),
            actions: [
              MaterialButton(
                  onPressed: () {
                    // Add new stock
                    getStockQuote(symbolCtrl.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Save')),
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  void goToStockPage(Stock stock) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => StockPage(stock: stock)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Soldi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Watchlist",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                IconButton(
                    onPressed: _showAddStockDialog, icon: const Icon(Icons.add))
              ],
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: stockFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (stocks.isEmpty) {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
                    return ListView.builder(
                      itemCount: stocks.length,
                      itemBuilder: (context, index) {
                        double price = stocks[index].currentPrice;
                        double open = stocks[index].todaysOpen;
                        double percentChange = (price - open) / open * 100;
                        String info = "\$${price.toStringAsFixed(2)} ${percentChange.toStringAsFixed(2)}%";
                        return ListTile(
                          title: Text(stocks[index].symbol,
                              style: const TextStyle(fontSize: 16)),
                          trailing: Text(info,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: price > open
                                      ? Colors.green
                                      : (price < open
                                          ? Colors.red
                                          : Colors.black))),
                          onTap: () => goToStockPage(stocks[index]),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Error loading data'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:soldi/models/stock_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleChartWidget extends StatelessWidget {
  final List<StockData> timeSeries;
  CandleChartWidget({required this.timeSeries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries>[
        CandleSeries<StockData, DateTime>(
          dataSource: timeSeries,
          xValueMapper: (StockData ts, _) => ts.date,
          lowValueMapper: (StockData ts, _) => ts.low,
          highValueMapper: (StockData ts, _) => ts.high,
          openValueMapper: (StockData ts, _) => ts.open,
          closeValueMapper: (StockData ts, _) => ts.close,
          enableSolidCandles: true,
        )
      ]
    );
  }
}

import 'package:flutter/material.dart';
import 'package:soldi/models/time_series.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleChartWidget extends StatelessWidget {
  final List<TimeSeries> timeSeries;
  CandleChartWidget({required this.timeSeries});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries>[
        CandleSeries<TimeSeries, DateTime>(
          dataSource: timeSeries,
          xValueMapper: (TimeSeries ts, _) => ts.date,
          lowValueMapper: (TimeSeries ts, _) => ts.low,
          highValueMapper: (TimeSeries ts, _) => ts.high,
          openValueMapper: (TimeSeries ts, _) => ts.open,
          closeValueMapper: (TimeSeries ts, _) => ts.close,
          enableSolidCandles: true,
        )
      ]
    );
  }
}

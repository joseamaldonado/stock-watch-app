import 'package:flutter/material.dart';
import 'package:soldi/models/day.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleChartWidget extends StatelessWidget {
  final List<Day> days;
  CandleChartWidget({required this.days});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries>[
        CandleSeries<Day, DateTime>(
          dataSource: days,
          xValueMapper: (Day day, _) => day.date,
          lowValueMapper: (Day day, _) => day.low,
          highValueMapper: (Day day, _) => day.high,
          openValueMapper: (Day day, _) => day.open,
          closeValueMapper: (Day day, _) => day.close,
          enableSolidCandles: true,
        )
      ]
    );
  }
}

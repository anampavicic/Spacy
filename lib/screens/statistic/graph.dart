import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../models/chart_data.dart';

class LineChartWidget extends StatelessWidget {
  final List<charts.Series<ChartData, int>> seriesList;
  final bool animate;

  LineChartWidget(this.seriesList, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: charts.LineChart(
        seriesList,
        animate: animate,
        domainAxis: charts.AxisSpec<int>(
          renderSpec: charts.NoneRenderSpec(),
        ),
      ),
    );
  }
}

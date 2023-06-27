import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../models/chart_data.dart';
import '../models/statistic_theme.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar_one_button.dart';

class StatisticPage extends StatefulWidget {
  final StatisticTheme statisticTheme;
  const StatisticPage({super.key, required this.statisticTheme});

  //const SignIn({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  void middleButton() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GradientBoxDecoration.gradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 25.0),
            Center(
              child: Text(
                'Statistic',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Successfully completed cards',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            _buildHalfRedBlackBox(
                widget.statisticTheme.percantageOfSolvedCardsByUser),
            Text(
              'Completed by you',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16.0),
            _buildHalfRedBlackBox(
                widget.statisticTheme.percantageOfSolvedCardsByEveryOne),
            Text(
              'Completed by everyone',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Successfully completed cards per day',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            _buildLineChart(widget.statisticTheme.graphUser),
            Text(
              'Completed by you',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16.0),
            _buildLineChart(widget.statisticTheme.graphEveryOne),
            Text(
              'Completed by everyone',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your top 3 best cards',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16.0),
            _buildCardBox(widget.statisticTheme.topTreeCards[0]),
            SizedBox(height: 16.0),
            _buildCardBox(widget.statisticTheme.topTreeCards[1]),
            SizedBox(height: 16.0),
            _buildCardBox(widget.statisticTheme.topTreeCards[2]),
            SizedBox(height: 16.0),
            Text(
              'Your top 3 worst cards',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16.0),
            _buildCardBox(widget.statisticTheme.worstTreeCards[0]),
            SizedBox(height: 16.0),
            _buildCardBox(widget.statisticTheme.worstTreeCards[1]),
            SizedBox(height: 16.0),
            _buildCardBox(widget.statisticTheme.worstTreeCards[2]),
          ],
        ),
        bottomNavigationBar: CustomConvexBottomAppBarOneButton(
          middleIcon: Icons.check,
          middleButtonPressed: middleButton,
        ),
      ),
    );
  }

  Widget _buildHalfRedBlackBox(double percent) {
    Random random = Random();
    int randomNumber = random.nextInt(101);
    return Container(
      height: 50.0,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: randomNumber,
                  child: Container(color: Color(0xFF001125)),
                ),
                Expanded(
                  flex: 100 - randomNumber,
                  child: Container(color: Colors.white70),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8.0,
            left: 8.0,
            child: Text(
              randomNumber.toStringAsFixed(2) + '%',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<ChartData> d) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      height: 150.0,
      child: charts.LineChart(
        [
          charts.Series<ChartData, int>(
            id: 'chartData',
            colorFn: (_, __) =>
                charts.ColorUtil.fromDartColor(Color(0xFF001125)),
            domainFn: (ChartData data, _) => data.x,
            measureFn: (ChartData data, _) => data.y,
            data: d,
          ),
        ],
        animate: true,
        domainAxis: charts.NumericAxisSpec(
          showAxisLine: true,
          renderSpec: charts.GridlineRendererSpec(
            lineStyle:
                charts.LineStyleSpec(color: charts.MaterialPalette.transparent),
            labelStyle: charts.TextStyleSpec(
              fontSize: 0, // Remove numbers on x-axis
            ),
            axisLineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.gray.shadeDefault, thickness: 1),
          ),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          showAxisLine: true,
          renderSpec: charts.GridlineRendererSpec(
            lineStyle:
                charts.LineStyleSpec(color: charts.MaterialPalette.transparent),
            labelStyle: charts.TextStyleSpec(
              fontSize: 10, // Remove numbers on x-axis
            ),
            axisLineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.gray.shadeDefault, thickness: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildCardBox(String name) {
    return Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ));
  }
}

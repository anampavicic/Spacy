import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../models/chart_data.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar_one_button.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

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
            SizedBox(height: 16.0),
            _buildHalfRedBlackBox(),
            SizedBox(height: 16.0),
            _buildHalfRedBlackBox(),
            SizedBox(height: 16.0),
            _buildLineChart(),
            SizedBox(height: 16.0),
            _buildLineChart(),
            SizedBox(height: 16.0),
            Text(
              '3 Best Cards',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            _buildCardBox(),
            SizedBox(height: 16.0),
            _buildCardBox(),
            SizedBox(height: 16.0),
            _buildCardBox(),
            SizedBox(height: 16.0),
            Text(
              'Top 3 Worst Cards',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            _buildCardBox(),
            SizedBox(height: 16.0),
            _buildCardBox(),
            SizedBox(height: 16.0),
            _buildCardBox(),
          ],
        ),
        bottomNavigationBar: CustomConvexBottomAppBarOneButton(
          middleIcon: Icons.check,
          middleButtonPressed: middleButton,
        ),
      ),
    );
  }

  Widget _buildHalfRedBlackBox() {
    return Container(
      height: 50.0,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 30,
                child: Container(color: Colors.red),
              ),
              Expanded(
                flex: 70,
                child: Container(color: Colors.black),
              ),
            ],
          ),
          Positioned(
            top: 8.0,
            left: 8.0,
            child: Text(
              '30%',
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

  Widget _buildLineChart() {
    final data = [
      ChartData(0, 40),
      ChartData(1, 60),
      ChartData(2, 80),
      ChartData(2, 80),
      ChartData(2, 80),
      ChartData(2, 80),
      ChartData(2, 80),
      ChartData(4, 70),
      ChartData(4, 70),
    ];

    return Container(
      height: 200.0,
      child: charts.LineChart(
        [
          charts.Series<ChartData, int>(
            id: 'chartData',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (ChartData data, _) => data.x,
            measureFn: (ChartData data, _) => data.y,
            data: data,
          ),
        ],
        animate: true,
      ),
    );
  }

  Widget _buildCardBox() {
    return Container(
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black),
      ),
    );
  }
}

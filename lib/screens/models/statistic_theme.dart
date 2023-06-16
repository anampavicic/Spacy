import 'chart_data.dart';

class StatisticTheme {
  final double percantageOfSolvedCardsByUser;
  final double percantageOfSolvedCardsByEveryOne;
  final List<ChartData> graphUser;
  final List<ChartData> graphEveryOne;
  final List<String> topTreeCards;
  final List<String> worstTreeCards;

  StatisticTheme(
      this.percantageOfSolvedCardsByUser,
      this.percantageOfSolvedCardsByEveryOne,
      this.graphUser,
      this.graphEveryOne,
      this.topTreeCards,
      this.worstTreeCards);
}

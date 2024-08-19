import 'package:flutter/material.dart';

//서버
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // JSON 인코딩/디코딩에 필요

//차트
import 'package:fl_chart/fl_chart.dart';

// --차트 위젯--

//데이터
class PieSectionData {
  double value;
  final Color color;
  final String title;
  PieSectionData(
      {required this.value, required this.color, required this.title});
}

class BarSectionData {
  final int index;
  final double value;
  final Color color;
  final String title;
  BarSectionData(
      {required this.index,
      required this.value,
      required this.color,
      required this.title});
}

//파이 차트
class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State {
  int touchedIndex = -1;
  int selectedId = 1; // 선택된 ID (임의로 1로 설정)

  List<PieSectionData> chartData = [
    PieSectionData(value: 0, color: Colors.blue, title: "50%"),
    PieSectionData(value: 0, color: Colors.yellow, title: "30%"),
    PieSectionData(value: 0, color: Colors.green, title: "15%"),
    PieSectionData(value: 0, color: Colors.purple, title: "3%"),
    PieSectionData(value: 0, color: Colors.grey, title: "2%")
  ];

  List<double> chartDesignValue = [0, 40]; //간격, 크기
  List<double> sectionDesignValue = [];
  @override
  void initState() {
    super.initState();
    _fetchPieChartValues(selectedId);
  }

  Future<void> _fetchPieChartValues(int id) async {
    final url = Uri.parse('http://127.0.0.1:8000/search-pieData/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final values = json.decode(response.body)['values'] as List;
      setState(() {
        for (int i = 0; i < chartData.length; i++) {
          chartData[i].value = values[i].toDouble();
        }
      });
    } else {
      throw Exception('Failed to load pie chart values');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "강자 비율",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 1.3,
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: chartDesignValue[0],
                      centerSpaceRadius: chartDesignValue[1],
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        )
      ],
    );
  }

  //데이터 조절
  List<PieChartSectionData> showingSections() {
    return List.generate(chartData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: chartData[i].color,
        value: chartData[i].value,
        title: chartData[i].title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}

//바 차트

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  //데이터
  double maxValue = 100 + 20;
  List<BarSectionData> chartData = [
    BarSectionData(index: 0, value: 99, color: Colors.blue, title: "강팀"),
    BarSectionData(index: 1, value: 10, color: Colors.blue, title: "약팀"),
    BarSectionData(index: 2, value: 40, color: Colors.blue, title: "중팀"),
    BarSectionData(index: 3, value: 3, color: Colors.blue, title: "최약팀"),
    BarSectionData(index: 4, value: 60, color: Colors.blue, title: "A팀"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "우승 확률",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: titlesData,
                borderData: borderData,
                barGroups: barGroups,
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue,
              ),
            ),
          )
        ],
      ),
    );
  }

  //제목
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    text = chartData[value.toInt()].title;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  //데이터
  List<BarChartGroupData> get barGroups => chartData
      .map((e) => BarChartGroupData(
            x: e.index,
            barRods: [
              BarChartRodData(
                toY: e.value,
                gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          ))
      .toList();

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}

//라인 차트
class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State {
  LineChartWidgetState({
    Color? line1Color,
    Color? line2Color,
    Color? betweenColor,
  })  : line1Color = line1Color ?? Colors.blue,
        line2Color = line2Color ?? Colors.purple,
        betweenColor = betweenColor ?? Color.fromRGBO(0, 255, 255, 0.5);

  final Color line1Color;
  final Color line2Color;
  final Color betweenColor;

  List<String> xLabel = ["1", "2", "3", "4", "5", "6", "7"];

  String yLabel = '';

  List<FlSpot> charData = [
    FlSpot(0, 4),
    FlSpot(1, 3.5),
    FlSpot(2, 4.5),
    FlSpot(3, 1),
    FlSpot(4, 10),
    FlSpot(5, 4),
    FlSpot(6, 7),
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    String text;
    text = xLabel[value.toInt()];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${yLabel} ${value}',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "우승 성공률 흐름",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 18,
              top: 10,
              bottom: 4,
            ),
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    //여기서 다른 차트 데이터 추가 가능
                    spots: charData,
                    isCurved: true,
                    barWidth: 2,
                    color: line1Color,
                    dotData: const FlDotData(
                      show: false,
                    ),
                  ),
                  LineChartBarData(
                    //여기서 다른 차트 데이터 추가 가능
                    spots: charData,
                    isCurved: true,
                    barWidth: 2,
                    color: line1Color,
                    dotData: const FlDotData(
                      show: false,
                    ),
                  ),
                ],
                betweenBarsData: [
                  BetweenBarsData(
                    fromIndex: 0,
                    toIndex: 1,
                    color: betweenColor,
                  )
                ],
                minY: 0,
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitleWidgets,
                      interval: 1,
                      reservedSize: 36,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  checkToShowHorizontalLine: (double value) {
                    return value == 1 || value == 6 || value == 4 || value == 5;
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

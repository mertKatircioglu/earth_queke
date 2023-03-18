import 'package:earth_queke/global/globals.dart';
import 'package:earth_queke/view_models/queke_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/preferences_service.dart';

class LineChartSample5 extends StatefulWidget {
  EarthQuakeViewModel? dataModel;
   LineChartSample5({
    super.key,
    Color? gradientColor1,
    this.dataModel,
    Color? gradientColor2,
    Color? gradientColor3,
    Color? indicatorStrokeColor,
  }) : gradientColor1 = gradientColor1 ?? Colors.blue,
        gradientColor2 = gradientColor2 ?? Colors.pink,
        gradientColor3 = gradientColor3 ?? Colors.red,
        indicatorStrokeColor = indicatorStrokeColor ?? Colors.white;

  final Color gradientColor1;
  final Color gradientColor2;
  final Color gradientColor3;
  final Color indicatorStrokeColor;

  @override
  State<LineChartSample5> createState() => _LineChartSample5State();
}

class _LineChartSample5State extends State<LineChartSample5> {
  List<int> get showIndexes => const [0,1,2,3,4,5];

  int? m1=0;
  int? m2=0;
  int? m3=0;
  int? m4=0;
  int? m5=0;
  int? m6=0;
  int? m7=0;
  List<String> months = [
    '',
    'OCAK',
    'ŞUBAT',
    'MART',
    'NİSAN',
    'MAYIS',
    'HAZİRAN',
    'TEMMUZ',
    'AĞUSTOS',
    'EYLÜL',
    'EKİM',
    'KASIM',
    'ARALIK'
  ];
  String currentCity ='';

  List<FlSpot> get allSpots =>  [
    FlSpot(0, m1!.toDouble()),
    FlSpot(1, m2!.toDouble()),
    FlSpot(2, m3!.toDouble()),
    FlSpot(3, m4!.toDouble()),
    FlSpot(4, m5!.toDouble()),
    FlSpot(5, m6!.toDouble()),
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.pink,
      fontFamily: 'Digital',
      fontSize: 14 * chartWidth / 500,
    );
    String text;

    switch (value.toInt()) {

      case 0:
        text = months.elementAt(int.parse(DateFormat('MM').format(DateTime(DateTime.now().year,(DateTime.now().month-5),)))).toString();
        break;
      case 1:
        text = months.elementAt(int.parse(DateFormat('MM').format(DateTime(DateTime.now().year,DateTime.now().month-4,)))).toString();
        break;
      case 2:
        text =months.elementAt(int.parse(DateFormat('MM').format(DateTime(DateTime.now().year,DateTime.now().month-3,)))).toString();
        break;
      case 3:
        text = months.elementAt(int.parse(DateFormat('MM').format(DateTime(DateTime.now().year,DateTime.now().month-2,)))).toString();
        break;
      case 4:
        text = months.elementAt(int.parse(DateFormat('MM').format(DateTime(DateTime.now().year,DateTime.now().month-1,)))).toString();
        break;
      case 5:
        text = months.elementAt(int.parse(DateFormat('MM').format(DateTime(DateTime.now().year,DateTime.now().month)))).toString();
        break;

      default:
        return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }


  loadData() async{
    sharedPreferences = await SharedPreferences.getInstance();
    var city = sharedPreferences!.getString('currentCity');
    var d1 = DateFormat('yyy.MM').format(DateTime(DateTime.now().year,DateTime.now().month-6));
    var d2 = DateFormat('yyy.MM').format(DateTime(DateTime.now().year,DateTime.now().month-5));
    var d3 = DateFormat('yyy.MM').format(DateTime(DateTime.now().year,DateTime.now().month-4));
    var d4 = DateFormat('yyy.MM').format(DateTime(DateTime.now().year,DateTime.now().month-3));
    var d5 = DateFormat('yyy.MM').format(DateTime(DateTime.now().year,DateTime.now().month-2));
    var d6 = DateFormat('yyy.MM').format(DateTime(DateTime.now().year,DateTime.now().month-1));
    var d7 = DateFormat('yyy.MM').format(DateTime(DateTime.now().year,DateTime.now().month));
   // print(d1);
    print(d2);
   await widget.dataModel!.getAnnualDataFromUi('HATAY').then((value) {
     setState(() {
       m1 = value.where((i) => i['date'].contains('$d1')).length;
       m2 = value.where((i) => i['date'].contains('$d2')).length;
       m3 = value.where((i) => i['date'].contains('$d3')).length;
       m4 = value.where((i) => i['date'].contains('$d4')).length;
       m5 = value.where((i) => i['date'].contains('$d5')).length;
       m6 = value.where((i) => i['date'].contains('$d6')).length;
       m7 = value.where((i) => i['date'].contains('$d7')).length;

     });


    });
  }



  @override
  void initState() {
        super.initState();
        loadData();
  }

  @override
  Widget build(BuildContext context) {

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showIndexes,
        spots: allSpots,
        isCurved: true,
        barWidth: 1.5,
        shadow: const Shadow(
          blurRadius: 8,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              widget.gradientColor1.withOpacity(0.4),
              widget.gradientColor2.withOpacity(0.4),
              widget.gradientColor3.withOpacity(0.4),
            ],
          ),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: [
            widget.gradientColor1,
            widget.gradientColor2,
            widget.gradientColor3,
          ],
          stops: const [0.1, 0.4, 0.9],
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 1.0,
          vertical: 5,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return LineChart(
            LineChartData(
              showingTooltipIndicators: showIndexes.map((index) {
                return ShowingTooltipIndicators([
                  LineBarSpot(
                    tooltipsOnBar,
                    lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index],
                  ),
                ]);
              }).toList(),
              lineTouchData: LineTouchData(
                enabled: false,
                getTouchedSpotIndicator:

                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: Colors.pink,
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 3,
                              color: lerpGradient(
                                barData.gradient!.colors,
                                barData.gradient!.stops!,
                                percent / 100,
                              ),
                              strokeWidth: 2,
                              strokeColor: widget.indicatorStrokeColor,
                            ),
                      ),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  tooltipPadding: const EdgeInsets.all(4.0),
                  tooltipBgColor: Colors.pink,
                  tooltipRoundedRadius: 4,

                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      return LineTooltipItem(
                        lineBarSpot.y.toString().replaceAll('.0', ''),
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: lineBarsData,
              minY: 0,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: const Text(''),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return bottomTitleWidgets(
                        value,
                        meta,
                        constraints.maxWidth,
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitles: AxisTitles(
                  axisNameWidget: const Text(''),
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                topTitles: AxisTitles(
                  axisNameWidget: const Text(
                    '',
                    textAlign: TextAlign.left,
                  ),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 0,
                  ),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.white54,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];
    final leftColor = colors[s];
    final rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
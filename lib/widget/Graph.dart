import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatefulWidget {
  List<String> label;
  List<double> value;
  Graph(this.label, this.value);
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(width: 1000, height: 200, child: LineChart(mainData())),
      ),
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    for (var i = 0; i < widget.label.length; i++) {
      spots.add(FlSpot(i.toDouble(), widget.value.elementAt(i)));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) => const TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 8),
            getTitles: (value) {
              int val = value.toInt();
              return widget.label.elementAt(val).toString();
              //return final_h_bar.elementAt(val).toString();
            },
            margin: 8,
            rotateAngle: 90),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 8,
          ),
          getTitles: (value) {
            int val = value.toInt();
            return val.toString();
            //return this.value.elementAt(val).toString();
            //return verical_bar.elementAt(val).toString();
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.label.length.toDouble() - 1,
      minY: widget.value.reduce(min) - 1,
      maxY: widget.value.reduce(max) + 1,
      lineBarsData: [
        LineChartBarData(
          spots: (spots),
          isCurved: true,
          colors: widget.gradientColors,
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: widget.gradientColors
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ],
    );
  }
}

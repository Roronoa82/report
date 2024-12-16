// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'bloc/summary_bloc.dart';
import 'bloc/summary_state.dart';

final logger = Logger();

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          if (state is SummaryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SummaryLoaded) {
            final lineSpots = getLineChartData(state.summaries);
            final barGroups = getBarChartData(state.summaries);
            logger.e(state.summaries);

            return Column(
              children: [
                // Line Chart
                Expanded(
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: lineSpots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Bar Chart
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barGroups: barGroups,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          axisNameWidget: Text('จำนวนเงิน'),
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text('วัน'),
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is SummaryError) {
            return Center(child: Text('Error loading data'));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

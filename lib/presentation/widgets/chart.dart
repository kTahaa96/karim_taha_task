import 'package:flutter/material.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/core/order_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatelessWidget {
  final int nonReturnedOrders;
  final int returnsCount;

  const PieChart({required this.nonReturnedOrders, required this.returnsCount});

  @override
  Widget build(BuildContext context) {
    final totalOrders = nonReturnedOrders + returnsCount;
    final nonReturnedPercentage = (nonReturnedOrders / totalOrders) * 100;
    final returnedPercentage = (returnsCount / totalOrders) * 100;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: MainColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: SfCircularChart(
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          PieSeries<OrderData, String>(
            dataSource: [
              OrderData(
                'Delivered Orders: $nonReturnedOrders',
                nonReturnedOrders.toDouble(),
              ),
              OrderData(
                'Returned Orders: $returnsCount',
                returnsCount.toDouble(),
              ),
            ],
            xValueMapper: (OrderData data, _) => data.label,
            yValueMapper: (OrderData data, _) => data.value,
            pointColorMapper: (OrderData data, _) {
              return data.label.contains('Delivered Orders')
                  ? MainColors.primary
                  : Colors.red;
            },
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/domain/entities/order_entity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';
import 'package:intl/intl.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Over Time'),
        backgroundColor: MainColors.snow,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            final orders = state.orders;

            final chartData = _prepareMonthlyChartData(orders);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: chartData.length * 80.0,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelRotation: 45,
                      title: AxisTitle(
                        text: 'Months',
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: MainColors.black,
                        ),
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Orders',
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: MainColors.black,
                        ),
                      ),
                      minimum: 0,
                      labelStyle: TextStyle(
                        color: MainColors.black,
                      ),
                    ),
                    series: <ChartSeries>[
                      // Line Chart for Non-Returned Orders with Gradient
                      LineSeries<_MonthlyData, String>(
                        dataSource: chartData,
                        xValueMapper: (_MonthlyData data, _) => data.month,
                        yValueMapper: (_MonthlyData data, _) => data.nonReturnedOrders,
                        name: 'Delivered Orders',
                        color: MainColors.primary,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          color: MainColors.primary,
                          borderColor: Colors.white,
                          borderWidth: 2,
                        ),
                        width: 2,
                        enableTooltip: true,
                      ),
                      // Line Chart for Returned Orders
                      LineSeries<_MonthlyData, String>(
                        dataSource: chartData,
                        xValueMapper: (_MonthlyData data, _) => data.month,
                        yValueMapper: (_MonthlyData data, _) => data.returnedOrders,
                        name: 'Returned Orders',
                        color: Colors.red,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          color: Colors.red,
                          borderColor: Colors.white,
                          borderWidth: 2,
                        ),
                        width: 2,
                        enableTooltip: true,
                      ),
                    ],
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                      alignment: ChartAlignment.center,
                      title: LegendTitle(text: 'Orders Statistics'),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Prepare monthly chart data from orders
  List<_MonthlyData> _prepareMonthlyChartData(List<OrderEntity> orders) {
    final Map<String, _MonthlyData> monthlyData = {};

    for (var order in orders) {
      final month = DateFormat('MMM yyyy').format(order.registered);

      if (!monthlyData.containsKey(month)) {
        monthlyData[month] =
            _MonthlyData(month: month, totalOrders: 0, returnedOrders: 0, nonReturnedOrders: 0);
      }

      monthlyData[month]!.totalOrders++;

      // Increment non-returned orders by calculating totalOrders - returnedOrders
      monthlyData[month]!.nonReturnedOrders = monthlyData[month]!.totalOrders - monthlyData[month]!.returnedOrders;

      if (order.status == 'RETURNED') {
        monthlyData[month]!.returnedOrders++;
      }
    }

    final chartData = monthlyData.values.toList();
    chartData.sort((a, b) => DateFormat('MMM yyyy')
        .parse(a.month)
        .compareTo(DateFormat('MMM yyyy').parse(b.month)));
    return chartData;
  }
}

/// Data model for monthly chart data
class _MonthlyData {
  final String month;
  int totalOrders;
  int returnedOrders;
  int nonReturnedOrders; // Added this property for non-returned orders

  _MonthlyData({
    required this.month,
    required this.totalOrders,
    required this.returnedOrders,
    required this.nonReturnedOrders,
  });
}

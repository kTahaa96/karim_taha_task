import 'package:flutter/material.dart';
import 'package:karim_taha_task/domain/entities/order_entity.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Syncfusion package
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Over Time'),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrderLoaded) {
            final orders = state.orders;  // Access orders from the loaded state
            // Prepare data to show in the chart: Group by date and count orders
            final orderCountsPerDate = _groupOrdersByDate(orders);

            // Data for the chart
            List<ChartData> chartData = _prepareChartData(orderCountsPerDate);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 45,
                  isVisible: true,
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: chartData.isNotEmpty ? chartData.map((e) => e.orderCount).reduce((a, b) => a > b ? a : b) + 1 : 10,
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                title: ChartTitle(
                  text: 'Number of Orders Over Time',
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                series: <ChartSeries>[
                  // BarChartSeries for orders
                  BarSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => DateFormat('MM/dd/yyyy').format(data.date),
                    yValueMapper: (ChartData data, _) => data.orderCount,
                    color: const Color(0xff016A40), // Green bar color
                    width: 0.6, // Bar width
                    borderRadius: BorderRadius.circular(8),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink(); // Default case
        },
      ),
    );
  }

  // Helper function to group orders by date
  Map<String, int> _groupOrdersByDate(List<OrderEntity> orders) {
    Map<String, int> orderCounts = {};

    for (var order in orders) {
      final date = DateFormat('MM/dd/yyyy').format(order.registered);  // Format the date
      orderCounts[date] = (orderCounts[date] ?? 0) + 1;
    }

    return orderCounts;
  }

  // Prepare chart data from the grouped orders
  List<ChartData> _prepareChartData(Map<String, int> orderCountsPerDate) {
    List<ChartData> chartData = [];

    orderCountsPerDate.forEach((date, count) {
      final parsedDate = DateFormat('MM/dd/yyyy').parse(date);  // Convert string date back to DateTime
      chartData.add(ChartData(parsedDate, count));
    });

    chartData.sort((a, b) => a.date.compareTo(b.date)); // Sort by date

    return chartData;
  }
}

// ChartData class to store the date and order count
class ChartData {
  final DateTime date;
  final int orderCount;

  ChartData(this.date, this.orderCount);
}

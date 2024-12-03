import 'package:flutter/material.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/core/mothly_date.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
        backgroundColor: MainColors.snow,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            final orders = state.orders;
            final chartData = context.read<OrderCubit>().prepareMonthlyChartData(orders);

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
                      labelStyle: const TextStyle(
                        color: MainColors.black,
                      ),
                    ),
                    series: <ChartSeries>[
                      LineSeries<MonthlyData, String>(
                        dataSource: chartData,
                        xValueMapper: (MonthlyData data, _) => data.month,
                        yValueMapper: (MonthlyData data, _) =>
                            data.nonReturnedOrders,
                        name: 'Delivered Orders',
                        color: MainColors.primary,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          color: MainColors.primary,
                          borderColor: Colors.white,
                          borderWidth: 2,
                        ),
                        width: 2,
                        enableTooltip: true,
                      ),
                      LineSeries<MonthlyData, String>(
                        dataSource: chartData,
                        xValueMapper: (MonthlyData data, _) => data.month,
                        yValueMapper: (MonthlyData data, _) =>
                            data.returnedOrders,
                        name: 'Returned Orders',
                        color: Colors.red,
                        markerSettings: const MarkerSettings(
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
}

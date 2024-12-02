import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/core/order_data.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: MainColors.primary,
              ),
            );
          } else if (state is OrderLoaded) {
            final totalOrders = state.totalOrders;
            final total = state.total.toStringAsFixed(2);
            final returnsCount = state.returnsCount;
            final nonReturnedOrders = totalOrders - returnsCount;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildMetricCards(
                  totalOrders,
                  returnsCount,
                  total,
                ),
                const SizedBox(height: 24),
                Container(
                  height: 250,
                  child: SfCircularChart(
                    title: ChartTitle(text: 'Orders vs Returns'),
                    legend: Legend(isVisible: true),
                    series: <CircularSeries>[
                      PieSeries<OrderData, String>(
                        dataSource: [
                          OrderData(
                              'Total Orders', nonReturnedOrders.toDouble()),
                          OrderData('Returned Orders', returnsCount.toDouble()),
                        ],
                        xValueMapper: (OrderData data, _) => data.label,
                        yValueMapper: (OrderData data, _) => data.value,
                        pointColorMapper: (OrderData data, _) {
                          if (data.label == 'Total Orders') {
                            return MainColors.primary;
                          } else {
                            return Colors.red;
                          }
                        },
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Top Buyers',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.topBuyers.length,
                    itemBuilder: (context, index) {
                      var buyer = state.topBuyers[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Card(
                          color: Colors.blueAccent,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  buyer.key,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${buyer.value.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back,',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Karim Taha',
          style: TextStyle(
            fontSize: 30,
            color: MainColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCards(int totalOrders, int returnsCount, String total) {
    return Stack(
      children: [
        _buildMetricCard(
          'Total Delivered Orders',
          "$totalOrders Orders",
          MainColors.primary,
          0,
        ),
        _buildMetricCard(
          'Returned Orders',
          "$returnsCount Orders",
          Colors.red,
          120,
        ),
        _buildMetricCard(
          'Total Value',
          "$total USD",
          Colors.blueAccent,
          240,
          last: true,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    Color color,
    double top, {
    bool? last,
  }) {
    return Container(
      width: double.infinity,
      height: last == true ? 150 : 180,
      margin: EdgeInsets.only(top: top),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

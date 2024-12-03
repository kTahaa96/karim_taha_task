import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/domain/entities/order_entity.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(color: MainColors.primary),
            );
          } else if (state is OrderLoaded) {
            return _buildContent(state);
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(OrderLoaded state) {
    final totalOrders = state.totalOrders;
    final totalIncome = state.total.toStringAsFixed(2);
    final returnsCount = state.returnsCount;
    final nonReturnedOrders = totalOrders - returnsCount;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildMetricCard(totalIncome),
        const SizedBox(height: 24),
        Row(
          children: [
            const Text(
              'My Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MainColors.black,
              ),
            ),
            Text(
              ' ($totalOrders Order)',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: MainColors.gray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildPieChart(nonReturnedOrders, returnsCount),
        const SizedBox(height: 24),
        const Text(
          'Latest Purchases',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MainColors.black,
          ),
        ),
        _buildOrderList(state.orders),
      ],
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
            color: MainColors.gray,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Karim Taha',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: MainColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String value) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 140,
            decoration: const BoxDecoration(
              color: MainColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Income',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: MainColors.gray,
                      ),
                    ),
                    Text(
                      '+20% comapared to last month',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: MainColors.black,
                      ),
                    ),
                    const Text(
                      ' \$',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: MainColors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(int nonReturnedOrders, int returnsCount) {
    // Calculate total orders
    final totalOrders = nonReturnedOrders + returnsCount;

    // Calculate percentages
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
                '${nonReturnedPercentage.toStringAsFixed(1)}%',
              ),
              OrderData(
                'Returned Orders: $returnsCount',
                returnsCount.toDouble(),
                '${returnedPercentage.toStringAsFixed(1)}%',
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

  Widget _buildOrderList(List<OrderEntity> orders) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (_, index) => const SizedBox(height: 20),
      itemBuilder: (_, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderEntity order) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: MainColors.white,
        boxShadow: [
          BoxShadow(
            color: MainColors.primary.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          order.buyer,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MainColors.black,
          ),
        ),
        subtitle: Text(
          DateFormat('yyyy-MM-dd').format(order.registered),
          style: const TextStyle(
            fontSize: 14,
            color: MainColors.gray,
          ),
        ),
        trailing: Text(
          '${order.price.toStringAsFixed(2)} \$',
          style: const TextStyle(
              fontSize: 16,
              color: MainColors.black,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
class OrderData {
  final String label;
  final double value;
  final String percentage;

  OrderData(this.label, this.value, this.percentage);
}

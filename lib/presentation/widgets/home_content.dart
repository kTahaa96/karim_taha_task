import 'package:flutter/material.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';
import 'package:karim_taha_task/presentation/widgets/chart.dart';
import 'package:karim_taha_task/presentation/widgets/header.dart';
import 'package:karim_taha_task/presentation/widgets/income_card.dart';
import 'package:karim_taha_task/presentation/widgets/last_orders_list.dart';

class HomeScreenContent extends StatelessWidget {
  final OrderLoaded state;

  const HomeScreenContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalOrders = state.totalOrders;
    final totalIncome = state.total.toStringAsFixed(2);
    final returnsCount = state.returnsCount;
    final nonReturnedOrders = totalOrders - returnsCount;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      children: [
        const HomeScreenHeader(),
        const SizedBox(height: 24),
        IncomeCard(value: totalIncome),
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
        PieChart(
            nonReturnedOrders: nonReturnedOrders, returnsCount: returnsCount),
        const SizedBox(height: 24),
        const Text(
          'Latest Purchases',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MainColors.black,
          ),
        ),
        LastOrdersList(orders: state.orders),
      ],
    );
  }
}

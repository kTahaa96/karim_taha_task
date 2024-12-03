import 'package:flutter/material.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/domain/entities/order_entity.dart';
import 'package:intl/intl.dart';
class LastOrdersList extends StatelessWidget {
  final List<OrderEntity> orders ;
  const LastOrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
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

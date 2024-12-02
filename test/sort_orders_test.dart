import 'package:flutter_test/flutter_test.dart';
import 'package:karim_taha_task/core/chard_data.dart';
import 'package:karim_taha_task/domain/entities/order_entity.dart';
import 'package:intl/intl.dart';

void main() {
  test('Group orders by date', () {
    final orders = [
      OrderEntity(
          registered: DateTime(2024, 12, 1),
          id: '617ec83315ac5cc039950494',
          isActive: true,
          price: 1000,
          picture: '',

          company: 'TEST COMANY',
          buyer: 'TEST BUYER',
          status: 'TEST STATUS'),
      OrderEntity(
          registered: DateTime(2024, 12, 1),
          id: '617ec83315ac5cc039950494',
          isActive: true,
          price: 1000,
          picture: '',
          company: 'TEST COMANY',
          buyer: 'TEST BUYER',
          status: 'TEST STATUS'),
      OrderEntity(
          registered: DateTime(2024, 12, 2),
          id: '617ec83315ac5cc039950494',
          isActive: true,
          price: 1000,
          picture: '',

          company: 'TEST COMANY',
          buyer: 'TEST BUYER',
          status: 'TEST STATUS'),
    ];

    final orderCounts = groupOrdersByDate(orders);

    expect(orderCounts['12/01/2024'], 2);
    expect(orderCounts['12/02/2024'], 1);
  });
}

Map<String, int> groupOrdersByDate(List<OrderEntity> orders) {
  Map<String, int> orderCounts = {};

  for (var order in orders) {
    final date = DateFormat('MM/dd/yyyy').format(order.registered);
    orderCounts[date] = (orderCounts[date] ?? 0) + 1;
  }

  return orderCounts;
}

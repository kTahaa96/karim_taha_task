import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/core/mothly_date.dart';
import 'package:karim_taha_task/domain/entities/order_entity.dart';
import 'package:karim_taha_task/domain/repo/order_repository.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';
import 'package:intl/intl.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;

  OrderCubit(this.repository) : super(OrderInitial());

  Future<void> loadOrders() async {
    emit(OrderLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      final orders = await repository.getOrders();
      final totalOrders = orders.length;
      final totalRevenue = _calculateTotalRevenue(orders);
      final returnedOrders = _getReturnedOrders(orders);

      emit(OrderLoaded(
        orders: orders,
        totalOrders: totalOrders,
        total: totalRevenue,
        returnsCount: returnedOrders.length,
      ));
    } catch (e) {
      emit(OrderError('Failed to load orders'));
    }
  }

  double _calculateTotalRevenue(List<OrderEntity> orders) {
    return orders.isEmpty ? 0.0 : orders.map((order) => order.price).reduce((a, b) => a + b);
  }

  List<OrderEntity> _getReturnedOrders(List<OrderEntity> orders) {
    return orders.where((order) => order.status == 'RETURNED').toList();
  }

  List<MonthlyData> prepareMonthlyChartData(List<OrderEntity> orders) {
    final Map<String, MonthlyData> monthlyData = {};

    for (var order in orders) {
      final month = DateFormat('MMM yyyy').format(order.registered);

      if (!monthlyData.containsKey(month)) {
        monthlyData[month] = MonthlyData(month: month, totalOrders: 0, returnedOrders: 0, nonReturnedOrders: 0);
      }

      monthlyData[month]!.totalOrders++;

      if (order.status == 'RETURNED') {
        monthlyData[month]!.returnedOrders++;
      }

      monthlyData[month]!.nonReturnedOrders = monthlyData[month]!.totalOrders - monthlyData[month]!.returnedOrders;
    }

    final chartData = monthlyData.values.toList();
    chartData.sort((a, b) => DateFormat('MMM yyyy').parse(a.month).compareTo(DateFormat('MMM yyyy').parse(b.month)));
    return chartData;
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/core/mothly_date.dart';
import 'package:karim_taha_task/domain/entities/order_entity.dart';
import 'package:karim_taha_task/domain/repo/order_repository.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';
import 'package:intl/intl.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;
  final int loadLimit = 10; // Number of orders to load per batch
  int currentPage = 0;
  List<OrderEntity> loadedOrders = [];

  OrderCubit(this.repository) : super(OrderInitial());

  Future<void> loadOrders() async {
    emit(OrderLoading());
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate loading
      final orders = await repository.getOrders();

      emit(OrderLoaded(
        orders: orders,
        totalOrders: orders.length,
        total: _calculateTotalRevenue(orders),
        returnsCount: _getReturnedOrders(orders).length,
      ));
    } catch (e) {
      emit(OrderError('Failed to load orders'));
    }
  }

  Future<void> loadMoreOrders() async {
    if (currentPage * loadLimit < loadedOrders.length) return; // Check if there are more orders to load

    try {
      final orders = await repository.getOrders(); // Get all orders from the repository
      final nextOrders = orders.skip(currentPage * loadLimit).take(loadLimit).toList();

      currentPage++; // Increment the page after loading more orders
      loadedOrders.addAll(nextOrders); // Add the new orders to the loaded list

      emit(OrderLoaded(
        orders: loadedOrders,
        totalOrders: loadedOrders.length,
        total: _calculateTotalRevenue(loadedOrders),
        returnsCount: _getReturnedOrders(loadedOrders).length,
      ));
    } catch (e) {
      emit(OrderError('Failed to load more orders'));
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

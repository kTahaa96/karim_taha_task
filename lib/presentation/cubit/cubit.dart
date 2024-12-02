import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/domain/entities/order_entity.dart';
import 'package:karim_taha_task/domain/repo/order_repository.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;

  OrderCubit(this.repository) : super(OrderInitial());

  Future<void> loadOrders() async {
    emit(OrderLoading());
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate a delay
      final orders = await repository.getOrders();

      // Calculate metrics
      final totalOrders = orders.length;

      // Total sum of all orders
      final total = orders.isEmpty
          ? 0.0
          : orders.map((e) => e.price).reduce((a, b) => a + b);

      // Total sum of returned orders
      final returnedOrders =
          orders.where((e) => e.status == 'RETURNED').toList();
      final returnedTotal = returnedOrders.isEmpty
          ? 0.0
          : returnedOrders.map((e) => e.price).reduce((a, b) => a + b);

      // Calculate the top 3 buyers based on their total value

      // Assuming each order has these fields: buyer, price

      // Create a map to accumulate the total price per buyer
      final Map<String, double> buyerTotals = {};

      for (var order in orders) {
        // Parse the price to remove '$' and convert it to double
        double price = order.price;

        // Accumulate total value per buyer
        if (buyerTotals.containsKey(order.buyer)) {
          buyerTotals[order.buyer] = buyerTotals[order.buyer]! + price;
        } else {
          buyerTotals[order.buyer] = price;
        }
      }

      // Sort the buyers by total value in descending order and get top 3
      final topBuyers = buyerTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Take top 3 buyers
      final top3 = topBuyers.take(3).toList();



      // Emit state with calculated metrics
      emit(OrderLoaded(
        orders: orders,
        totalOrders: totalOrders,
        total: total,
        topBuyers: topBuyers,
        returnsCount: returnedOrders.length,
      ));
    } catch (e) {
      emit(OrderError('Failed to load orders'));
    }
  }
}

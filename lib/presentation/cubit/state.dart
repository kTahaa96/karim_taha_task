import 'package:karim_taha_task/domain/entities/order_entity.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

// In your OrderState class

class OrderLoaded extends OrderState {
  final int totalOrders;
  final double total;
  final int returnsCount;
  final List<OrderEntity> orders;

  OrderLoaded({
    required this.totalOrders,
    required this.total,
    required this.returnsCount,
    required this.orders,
  });
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}

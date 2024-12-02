import 'package:karim_taha_task/data/data_source/order_data_source.dart';
import 'package:karim_taha_task/domain/repo/order_repository.dart';

import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource dataSource;

  OrderRepositoryImpl(this.dataSource);

  @override
  Future<List<OrderEntity>> getOrders() async {
    final List<OrderModel> models = await dataSource.fetchOrders();
    return models.map((model) {
      final price = double.parse(model.price.replaceAll(RegExp(r'[^0-9.]'), ''));
      return OrderEntity(
        picture: model.picture,
        id: model.id,
        isActive: model.isActive,
        price: price,
        company: model.company,
        buyer: model.buyer,
        status: model.status,
        registered: DateTime.parse(model.registered),
      );
    }).toList();
  }
}

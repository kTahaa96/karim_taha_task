import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/order_model.dart';

class OrderDataSource {
  Future<List<OrderModel>> fetchOrders() async {
    final String response = await rootBundle.loadString('assets/orders.json');
    final List<dynamic> data = json.decode(response);
    return data.map((order) => OrderModel.fromJson(order)).toList();
  }
}

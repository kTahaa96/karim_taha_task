class OrderEntity {
  final String id;
  final bool isActive;
  final double price;
  final String company;
  final String buyer;
  final String status;
  final DateTime registered;

  OrderEntity({
    required this.id,
    required this.isActive,
    required this.price,
    required this.company,
    required this.buyer,
    required this.status,
    required this.registered,
  });
}

class MonthlyData {
  final String month;
  int totalOrders;
  int returnedOrders;
  int nonReturnedOrders;

  MonthlyData({
    required this.month,
    required this.totalOrders,
    required this.returnedOrders,
    required this.nonReturnedOrders,
  });
}

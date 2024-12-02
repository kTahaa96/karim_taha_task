import 'package:flutter/material.dart';

class LastOrdersList extends StatefulWidget {
  const LastOrdersList({super.key});

  @override
  State<LastOrdersList> createState() => _LastOrdersListState();
}

class _LastOrdersListState extends State<LastOrdersList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Last 5 Orders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: state.lastFiveOrders.length,
        //     itemBuilder: (context, index) {
        //       final order = state.lastFiveOrders[index];
        //       return Card(
        //         elevation: 4,
        //         margin: const EdgeInsets.symmetric(vertical: 8),
        //         child: ListTile(
        //           leading: CircleAvatar(
        //             backgroundColor: Colors.blueGrey,
        //             child: Text(
        //               order.buyer[0],
        //               style: const TextStyle(color: Colors.white),
        //             ),
        //           ),
        //           title: Text(order.buyer),
        //           subtitle: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text('Status: ${order.status}'),
        //               Text('Price: \$${order.price.toStringAsFixed(2)}'),
        //             ],
        //           ),
        //           trailing: Text(order.registered.toString()),
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

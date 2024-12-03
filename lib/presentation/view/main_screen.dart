import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/core/di.dart';
import 'package:karim_taha_task/data/data_source/order_data_source.dart';
import 'package:karim_taha_task/data/repo_impl/order_repository_impl.dart';
import 'package:karim_taha_task/domain/repo/order_repository.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';
import 'package:karim_taha_task/presentation/view/graph_screen.dart';
import 'package:karim_taha_task/presentation/view/home_analytics_view.dart';

class MainScreen extends StatefulWidget {
  final OrderRepository repository;

  MainScreen({super.key}) : repository = OrderRepositoryImpl(OrderDataSource());

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  List<Widget> views = [const HomeScreen(), const GraphScreen()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => di<OrderCubit>()..loadOrders(),
        child: Scaffold(
          body: views[index],
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: MainColors.white,
              onTap: (newIndex) {
                setState(() {
                  index = newIndex;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: MainColors.gray,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.insert_chart,
                    color: MainColors.gray,
                  ),
                  label: 'Graph',
                ),
              ]),
        ));
  }
}

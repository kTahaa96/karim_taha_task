import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:google_fonts/google_fonts.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';
import 'package:karim_taha_task/presentation/view/graph_screen.dart';
import 'package:karim_taha_task/presentation/view/home_analytics_view.dart';
import 'package:karim_taha_task/presentation/view/main_screen.dart';

import 'data/data_source/order_data_source.dart';
import 'data/repo_impl/order_repository_impl.dart';
import 'domain/repo/order_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Initialize repositories here instead of in the constructor
  // final OrderDataSource dataSource = OrderDataSource();
  // final OrderRepository repository;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders Overview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        primaryColor: MainColors.primary,
        scaffoldBackgroundColor: MainColors.snow,
        cardColor: Colors.grey[850],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MainColors.primary,
          ),
        ),
      ),
      home:  MainScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => BlocProvider(
      //         create: (context) => OrderCubit(repository)..loadOrders(),
      //         child: const HomeScreen(),
      //       ),
      //   '/graph': (context) => const GraphScreen(),
      // },
    );
  }
}

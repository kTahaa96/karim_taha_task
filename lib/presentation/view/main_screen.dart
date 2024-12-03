import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/core/di.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';
import 'package:karim_taha_task/presentation/view/graph_screen.dart';
import 'package:karim_taha_task/presentation/view/home_analytics_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final List<Widget> views = const [
    HomeScreen(),
    GraphScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<OrderCubit>()..loadOrders(),
      child: Scaffold(
        body: Row(
          children: [
            if (kIsWeb) _buildNavigationBar(), // Web-specific nav bar
            Expanded(child: views[index]), // Main content
          ],
        ),
        bottomNavigationBar: kIsWeb
            ? null // Remove bottom nav for web
            : _buildBottomNavigationBar(), // Mobile-specific bottom nav
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: MainColors.white,
      currentIndex: index,
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
      ],
    );
  }

  Widget _buildNavigationBar() {
    return NavigationRail(
      extended: true,
      useIndicator: false,
      selectedLabelTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: MainColors.primary,
          fontFamily: 'Roboto'),
      unselectedLabelTextStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
        color: MainColors.black,
      ),
      backgroundColor: MainColors.secondary,
      selectedIndex: index,
      onDestinationSelected: (newIndex) {
        setState(() {
          index = newIndex;
        });
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home, color: MainColors.white),
          selectedIcon: Icon(Icons.home, color: MainColors.primary),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.insert_chart, color: MainColors.white),
          selectedIcon: Icon(Icons.insert_chart, color: MainColors.primary),
          label: Text('Graph'),
        ),
      ],
    );
  }
}

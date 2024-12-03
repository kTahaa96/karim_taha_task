import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karim_taha_task/core/colors.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';
import 'package:karim_taha_task/presentation/cubit/state.dart';
import 'package:karim_taha_task/presentation/widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(color: MainColors.primary),
            );
          } else if (state is OrderLoaded) {
            return HomeScreenContent(state: state);
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
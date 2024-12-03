import 'package:get_it/get_it.dart';
import 'package:karim_taha_task/data/data_source/order_data_source.dart';
import 'package:karim_taha_task/data/repo_impl/order_repository_impl.dart';
import 'package:karim_taha_task/domain/repo/order_repository.dart';
import 'package:karim_taha_task/presentation/cubit/cubit.dart';

final di = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Register Data Source
  di.registerLazySingleton<OrderDataSource>(() => OrderDataSource());

  // Register Repository
  di.registerLazySingleton<OrderRepository>(
        () => OrderRepositoryImpl(di<OrderDataSource>()),
  );

  // Register OrderCubit
  di.registerFactory<OrderCubit>(() => OrderCubit(di<OrderRepository>()));
}

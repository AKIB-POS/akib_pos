import 'package:akib_pos/features/dashboard/data/datasources/dahboard_remote_data_source.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_branches_cubit.dart';
import 'package:get_it/get_it.dart';

final dashboardInjection = GetIt.instance;

Future<void> initDashboardModule() async {
  //! Features - Dashboard
  // Remote Data Source
  dashboardInjection.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: dashboardInjection()),
  );

  // Repository
  dashboardInjection.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: dashboardInjection(),authSharedPref: dashboardInjection(),connectivity: dashboardInjection()),
  );

  // Cubit
  dashboardInjection.registerFactory(
    () => GetBranchesCubit(dashboardInjection()),
  );
}

import 'package:akib_pos/features/dashboard/data/datasources/dahboard_remote_data_source.dart';
import 'package:akib_pos/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_branches_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_accounting_summary_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_summary_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_summary_stock_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_dashboard_top_products_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_purchase_chart_cubit.dart';
import 'package:akib_pos/features/dashboard/presentation/bloc/get_sales_chart_cubit.dart';
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
  dashboardInjection.registerFactory(
    () => GetDashboardAccountingSummaryCubit(dashboardInjection()),
  );
  dashboardInjection.registerFactory(
    () => GetDashboardTopProductsCubit(dashboardInjection()),
  );
  dashboardInjection.registerFactory(
    () => GetSalesChartCubit(dashboardInjection()),
  );
  dashboardInjection.registerFactory(
    () => GetPurchaseChartCubit(dashboardInjection()),
  );
  dashboardInjection.registerFactory(
    () => GetDashboardSummaryHrdCubit(dashboardInjection()),
    
  );
  dashboardInjection.registerFactory(
    () => GetDashboardSummaryStockCubit(dashboardInjection()), // Register Stock Summary Cubit
  );

}

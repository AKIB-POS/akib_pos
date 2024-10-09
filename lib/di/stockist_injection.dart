import 'package:akib_pos/features/stockist/data/datasources/stockist_remote_data_source.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_material_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/add_vendor.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/expired_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_purchase_history_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_raw_material_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/get_vendor_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/material_detail_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/running_out_stock_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/stockist_recent_purchase_cubit.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/stockist_summary_cubit.dart';
import 'package:get_it/get_it.dart';

final stockistInjection = GetIt.instance;

Future<void> initStockistModule() async {
  //! Features - Stockist
  // Remote Data Source
  stockistInjection.registerLazySingleton<StockistRemoteDataSource>(
    () => StockistRemoteDataSourceImpl(client: stockistInjection()),
  );

  // Repository
  stockistInjection.registerLazySingleton<StockistRepository>(
    () => StockistRepositoryImpl(remoteDataSource: stockistInjection()),
  );

  // Cubit
  stockistInjection.registerFactory(
    () => StockistSummaryCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => StockistRecentPurchasesCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => ExpiredStockCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => RunningOutStockCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetVendorCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => AddVendorCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetRawMaterialCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => AddRawMaterialCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetPurchasesCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetMaterialDetailCubit(stockistInjection()),
  );
  stockistInjection.registerFactory(
    () => GetPurchaseHistoryCubit(stockistInjection()),
  );

}
  

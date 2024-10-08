import 'package:akib_pos/features/stockist/data/datasources/stockist_remote_data_source.dart';
import 'package:akib_pos/features/stockist/data/repositories/stockist_repository.dart';
import 'package:akib_pos/features/stockist/presentation/bloc/expired_stock_cubit.dart';
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

}
  

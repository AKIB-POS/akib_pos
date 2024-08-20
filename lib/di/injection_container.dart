import 'package:akib_pos/features/cashier/data/datasources/kasir_local_data_source.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_remote_data_source.dart';
import 'package:akib_pos/features/cashier/data/datasources/transaction_service.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/printer/printer_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/product/product_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/util/shared_prefs_helper.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Kasir
  // Bloc
  sl.registerFactory(
    () => ProductBloc(kasirRepository: sl(), localDataSource: sl()),
  );
  sl.registerFactory(
    () => VoucherCubit(sl()),
  );

  sl.registerFactory(
    () => TransactionCubit(sl()),
  );
  sl.registerFactory(
    () => BadgeCubit(sl()),
  );
  sl.registerFactory(
    () => MemberCubit(repository: sl()),
  );
  sl.registerFactory(
    () => PrinterCubit(bluetooth: sl(),sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<KasirRepository>(
    () => KasirRepositoryImpl(remoteDataSource: sl(),),
  );

  // Data sources
  sl.registerLazySingleton<KasirRemoteDataSource>(
    () => KasirRemoteDataSourceImpl(client: sl(), sharedPrefsHelper: sl()),
  );

  sl.registerLazySingleton<KasirLocalDataSource>(
    () => KasirLocalDataSource(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<TransactionService>(
    () => TransactionService(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<SharedPrefsHelper>(
    () => SharedPrefsHelper(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
    sl.registerLazySingleton(() => BlueThermalPrinter.instance);
}
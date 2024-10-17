import 'package:akib_pos/features/auth/data/datasources/local_data_source.dart/auth_shared_pref.dart';
import 'package:akib_pos/features/auth/data/datasources/remote_data_source/remote_auth_data_sources.dart';
import 'package:akib_pos/features/auth/data/repositories/auth_repository.dart';
import 'package:akib_pos/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:akib_pos/features/cashier/data/datasources/local/cashier_shared_pref.dart';
import 'package:akib_pos/features/cashier/data/datasources/local/kasir_local_data_source.dart';
import 'package:akib_pos/features/cashier/data/datasources/kasir_remote_data_source.dart';
import 'package:akib_pos/features/cashier/data/datasources/local/transaction_service.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/close_cashier/close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/expenditure/expenditure_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/open_cashier/open_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/post_close_cashier/post_close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/printer/printer_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/product/product_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/checkout/checkout_cubit.dart';
import 'package:akib_pos/util/shared_prefs_helper.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
final sl = GetIt.instance;

Future<void> init() async {

 //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  // sl.registerLazySingleton(() => BlueThermalPrinter.instance);
  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

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
    () => ExpenditureCubit(repository: sl()),
  );
  
  sl.registerFactory(
    () => CheckoutCubit(sl()),
  );

  sl.registerFactory(
    () => CloseCashierCubit(repository: sl()),
  );
  sl.registerFactory(
    () => PostCloseCashierCubit(repository: sl()),
  );
  sl.registerFactory(
    () => OpenCashierCubit(repository: sl()),
  );
  
  // sl.registerFactory(
  //   () => PrinterCubit(bluetooth: sl(),sharedPreferences: sl()),
  // );

 


  // Repository
  sl.registerLazySingleton<KasirRepository>(
    () => KasirRepositoryImpl(remoteDataSource: sl(), authSharedPref: sl(),),
  );


  // Data sources cashier
  sl.registerLazySingleton<KasirRemoteDataSource>(
    () => KasirRemoteDataSourceImpl(client: sl(), ),
  );
 

  sl.registerLazySingleton<KasirLocalDataSource>(
    () => KasirLocalDataSource(sharedPreferences: sl()),
  );
  
  
  sl.registerLazySingleton<TransactionService>(
    () => TransactionService(sharedPreferences: sl()),
  );


  //Features Auth
  //Cubit/bloc auth
  sl.registerFactory(
    () => AuthCubit(sl()),
  );

  // data source auth
 sl.registerLazySingleton<RemoteAuthDataSource>(
    () => RemoteAuthDataSourceImpl(client: sl(),),
  );
  sl.registerLazySingleton(() => AuthSharedPref(sl()));



  //repository auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(),sl()),
  );


  //! Core
  sl.registerLazySingleton<SharedPrefsHelper>(
    () => SharedPrefsHelper(sl()),
  );
  
}
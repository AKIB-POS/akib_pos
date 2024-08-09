import 'package:akib_pos/features/cashier/data/datasources/kasir_remote_data_source.dart';
import 'package:akib_pos/features/cashier/data/repositories/kasir_repository.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/product/product_bloc.dart';
import 'package:akib_pos/util/shared_prefs_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
final sl = GetIt.instance;


Future<void> init() async {
  //! Features - Kasir
  // Bloc
  sl.registerFactory(
    () => ProductBloc(kasirRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<KasirRepository>(
    () => KasirRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<KasirRemoteDataSource>(
    () => KasirRemoteDataSourceImpl(client: sl(), sharedPrefsHelper: sl()),
  );

  //! Core
  sl.registerLazySingleton<SharedPrefsHelper>(
    () => SharedPrefsHelper(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
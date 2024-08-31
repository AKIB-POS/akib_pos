import 'package:akib_pos/features/accounting/data/datasources/accounting_remote_data_source.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_summary_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final accountingInjection = GetIt.instance;

Future<void> initAccountingModule() async {
  //! Features - Accounting
  // Cubit
  accountingInjection.registerFactory(
    () => TransactionSummaryCubit(repository: accountingInjection()),
  );

  // Repository
  accountingInjection.registerLazySingleton<AccountingRepository>(
    () => AccountingRepositoryImpl(remoteDataSource: accountingInjection()),
  );

  // Data sources
  accountingInjection.registerLazySingleton<AccountingRemoteDataSource>(
    () => AccountingRemoteDataSourceImpl(client: accountingInjection()),
  );


}

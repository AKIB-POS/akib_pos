import 'package:akib_pos/features/accounting/data/datasources/accounting_remote_data_source.dart';
import 'package:akib_pos/features/accounting/data/datasources/local/employee_shared_pref.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/employee_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_interaction_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_summary_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final accountingInjection = GetIt.instance;

Future<void> initAccountingModule() async {
  //! Features - Accounting
  // Cubit

  accountingInjection.registerFactory(
    () => EmployeeCubit(repository: accountingInjection()),
  );

  accountingInjection.registerFactory(
    () => TransactionReportCubit(repository: accountingInjection()),
  );


  accountingInjection.registerFactory(
    () => TransactionSummaryCubit(repository: accountingInjection()),
  );
  accountingInjection.registerFactory(
    () => TransactionListCubit(repository: accountingInjection()),
  );

  accountingInjection.registerFactory(
    () => TransactionReportInteractionCubit(employeeSharedPref: accountingInjection())
  );

  // Repository
  accountingInjection.registerLazySingleton<AccountingRepository>(
    () => AccountingRepositoryImpl(
      remoteDataSource: accountingInjection(),
      employeeSharedPref: accountingInjection(),
      connectivity: accountingInjection(),
    ),
  );

  // Data sources
  accountingInjection.registerLazySingleton<AccountingRemoteDataSource>(
    () => AccountingRemoteDataSourceImpl(client: accountingInjection()),
  );

  accountingInjection.registerLazySingleton<EmployeeSharedPref>(
    () => EmployeeSharedPref(accountingInjection()),
  );


}

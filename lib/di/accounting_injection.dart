import 'package:akib_pos/features/accounting/data/datasources/accounting_remote_data_source.dart';
import 'package:akib_pos/features/accounting/data/datasources/local/employee_shared_pref.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/active_asset_cubit.dart';
import 'package:akib_pos/features/accounting/data/repositories/accounting_repository.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/asset_depreciation_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/pending_asset_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/cash_flow_report/cash_flow_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/purchased_product_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/total_expenditure_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/profit_loss_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/purchase_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/total_purchase_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/sales_product_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/sales_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/service_charge_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/service_charge_setting_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/tax_management_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/tax_management_and_tax_services/tax_management_setting_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/employee_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/transaction_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/transaction_report/transaction_report_interaction_cubit.dart';
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

  accountingInjection.registerFactory(() => TransactionReportInteractionCubit(
      employeeSharedPref: accountingInjection()));

  accountingInjection.registerFactory(
    () => SalesProductReportCubit(repository: accountingInjection()),
  );

  accountingInjection.registerFactory(
    () => PurchasedProductCubit(repository: accountingInjection()),
  );

  accountingInjection.registerFactory(
      () => CashFlowReportCubit(repository: accountingInjection()));

  accountingInjection.registerFactory(
    () => SalesReportCubit(repository: accountingInjection()),
  );

  accountingInjection.registerFactory(
    () => TotalPurchaseCubit(repository: accountingInjection()),
  );

  accountingInjection.registerFactory(
    () => PurchaseListCubit(repository: accountingInjection()),
  );

  accountingInjection.registerFactory(
    () => TotalExpenditureCubit(repository: accountingInjection()),
  );
  accountingInjection.registerFactory(
    () => ProfitLossCubit(repository: accountingInjection()),
  );
  accountingInjection.registerFactory(
    () => PendingAssetCubit(accountingInjection()),
  );
  accountingInjection.registerFactory(
    () => ActiveAssetCubit(accountingInjection()),
  );
  accountingInjection.registerFactory(
    () => AssetDepreciationCubit(repository:accountingInjection()),
  );

  accountingInjection.registerFactory(
    () => FinancialBalanceCubit(repository: accountingInjection()),
  );
  accountingInjection.registerFactory(
    () => ServiceChargeCubit(repository: accountingInjection()),
  );

   accountingInjection.registerFactory(
    () => ServiceChargeSettingCubit(repository: accountingInjection()),
  );
  accountingInjection.registerFactory(
    () => TaxManagementCubit(repository: accountingInjection()),
  );

   accountingInjection.registerFactory(
    () => TaxManagementSettingCubit(repository: accountingInjection()),
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

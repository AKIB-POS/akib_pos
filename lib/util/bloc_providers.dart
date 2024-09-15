import 'package:akib_pos/di/injection_container.dart';
import 'package:akib_pos/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviders {


  static List<BlocProvider> authBlocProviders() {
    return [
      BlocProvider(
          create: (context) => NavigationCubit(),
        ),
      BlocProvider(
        
        create: (context) => AuthCubit(sl()),
      ),
      // Add more auth-related BlocProviders here if needed
    ];
  }
  static List<BlocProvider> navigationBlocProviders() {
    return [
     
      // Add more auth-related BlocProviders here if needed
    ];
  }

  // static List<BlocProvider> cashierBlocProviders() {
  //   return [
  //     BlocProvider(
  //         create: (context) => ProductBloc(
  //           kasirRepository: sl(),
  //           localDataSource: sl(),
  //         )
  //           ..add(FetchCategoriesEvent())
  //           ..add(FetchSubCategoriesEvent())
  //           ..add(FetchProductsEvent())
  //           ..add(FetchAdditionsEvent())
  //           ..add(FetchVariantsEvent()),
  //       ),
  //       BlocProvider(
  //         create: (context) => CashierCubit(
  //           localDataSource: sl(),
  //           productBloc: sl<ProductBloc>(),
  //         )..loadData(),
  //       ),
  //       BlocProvider(
  //           create: (context) =>
  //               TransactionCubit(sl())), // Ensure this is provided here
  //       BlocProvider(
  //           create: (context) =>
  //               ProcessTransactionCubit()), // Ensure this is provided here
  //       BlocProvider(
  //           create: (context) =>
  //               VoucherCubit(sl())), // Ensure this is provided here
  //       BlocProvider(
  //           create: (context) =>
  //               BadgeCubit(sl())), // Ensure this is provided here
  //       BlocProvider(
  //           create: (context) =>
  //               CheckoutCubit(sl())), // Ensure this is provided here
  //       BlocProvider(
  //           create: (context) =>
  //               MemberCubit(repository: sl())),
  //       BlocProvider(
  //           create: (context) =>
  //               CloseCashierCubit(repository: sl())),
  //       BlocProvider(
  //           create: (context) =>
  //               PostCloseCashierCubit(repository: sl())),
  //       BlocProvider(
  //           create: (context) =>
  //               OpenCashierCubit(repository: sl())),
  //       BlocProvider(
  //           create: (context) =>
  //               ExpenditureCubit(repository: sl())),
  //       BlocProvider(
  //           create: (context) =>
  //               AuthCubit(sl())),
  //       BlocProvider(
  //           create: (context) =>
  //               PrinterCubit(bluetooth: sl(),sharedPreferences: sl())),


  //     // Add more cashier-related BlocProviders here if needed
  //   ];
  // }

  // static List<BlocProvider> accountingBlocProviders() {
  //   return [
  //      BlocProvider(
  //         create: (context) => TransactionSummaryCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => EmployeeCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => TransactionReportInteractionCubit(employeeSharedPref: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => TransactionListCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => TransactionReportCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => DateRangeCubit(),
  //       ),
  //       BlocProvider(
  //         create: (context) => SalesReportCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => SalesProductReportCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => DateRangePurchaseCubit(),
  //       ),
  //       BlocProvider(
  //         create: (context) => TotalPurchaseCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => PurchaseListCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => DateRangeExpenditureCubit(),
  //       ),
  //       BlocProvider(
  //         create: (context) => TotalExpenditureCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => DateRangeProfitLossCubit(),
  //       ),
  //       BlocProvider(
  //         create: (context) => ProfitLossCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => ProfitLossDetailsCubit(),
  //       ),
  //       BlocProvider(
  //         create: (context) => PurchasedProductCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => DateRangeCashFlowCubit(),
  //       ),
  //       BlocProvider(
  //         create: (context) => CashFlowReportCubit(repository: accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => PendingAssetCubit(accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => ActiveAssetCubit(accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => SoldAssetCubit(repository:accountingInjection()),
  //       ),
  //       BlocProvider(
  //         create: (context) => AssetDepreciationCubit(repository:accountingInjection()),
  //       ),

  //       BlocProvider(
  //         create: (context) => DateRangeFinancialBalanceCubit(),
  //       ),
  //        BlocProvider(
  //         create: (context) => FinancialBalanceCubit(repository: accountingInjection()),
  //       ),
  //        BlocProvider(
  //         create: (context) => ServiceChargeCubit(repository: accountingInjection()),
  //       ),
  //        BlocProvider(
  //         create: (context) => ServiceChargeSettingCubit(repository: accountingInjection()),
  //       ),
  //        BlocProvider(
  //         create: (context) => TaxManagementCubit(repository: accountingInjection()),
  //       ),
  //        BlocProvider(
  //         create: (context) => TaxManagementSettingCubit(repository: accountingInjection()),
  //       ),
  //     // Add more accounting-related BlocProviders here if needed
  //   ];
  // }


  //  static List<BlocProvider> hrdBlocProviders() {
  //   return [
  //   BlocProvider(
  //         create: (context) => AttendanceSummaryCubit(hrdInjection()),
  //       ),
  //     // Add more auth-related BlocProviders here if needed
  //   ];
  // }

  // Combine all providers into a single list
  static List<BlocProvider> getAllBlocProviders() {
    return [
      ...authBlocProviders(),
      ...navigationBlocProviders(),
      // ...cashierBlocProviders(),
      // ...accountingBlocProviders(),
      // ...hrdBlocProviders(),
    ];
  }
}
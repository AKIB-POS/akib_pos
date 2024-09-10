import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/di/accounting_injection.dart';
import 'package:akib_pos/di/injection_container.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/active_asset_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/asset_depreciation_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/pending_asset_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/asset_management/sold_asset_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/cash_flow_report/cash_flow_report_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/cash_flow_report/date_range_cash_flow_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/date_range_expenditure_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/purchased_product_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/expenditure_report/total_expenditure_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/date_range_financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/financial_balance_report/financial_balance_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/date_range_profit_loss_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/profit_loss_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/profit_loss/profit_loss_details_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/date_range_pruchase_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/purchase_list_cubit.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/purchasing_report/total_purchase_model.dart';
import 'package:akib_pos/features/accounting/presentation/bloc/sales_report.dart/date_range_cubit.dart';
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
import 'package:akib_pos/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/badge/badge_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/close_cashier/close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/expenditure/expenditure_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/member/member_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/open_cashier/open_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/post_close_cashier/post_close_cashier_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/printer/printer_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/product/product_bloc.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/process_transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/transaction/transaction_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/bloc/voucher/voucher_cubit.dart';
import 'package:akib_pos/features/cashier/presentation/checkout/checkout_cubit.dart';
import 'package:akib_pos/features/home/cubit/navigation_cubit.dart';
import 'package:akib_pos/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:akib_pos/di/injection_container.dart' as di;
import 'package:akib_pos/di/accounting_injection.dart' as accounting;
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';  // <-- This line imports the initializeDateFormatting function


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    await initializeDateFormatting('id', null);
  
  await _requestPermissions(); 
  //for auth and cashier injection initialization
  await di.init();
  //for accounting injection initialization
  await accounting.initAccountingModule();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            kasirRepository: sl(),
            localDataSource: sl(),
          )
            ..add(FetchCategoriesEvent())
            ..add(FetchSubCategoriesEvent())
            ..add(FetchProductsEvent())
            ..add(FetchAdditionsEvent())
            ..add(FetchVariantsEvent()),
        ),
        BlocProvider(
          create: (context) => CashierCubit(
            localDataSource: sl(),
            productBloc: sl<ProductBloc>(),
          )..loadData(),
        ),
        BlocProvider(
            create: (context) =>
                TransactionCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                ProcessTransactionCubit()), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                VoucherCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                BadgeCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                CheckoutCubit(sl())), // Ensure this is provided here
        BlocProvider(
            create: (context) =>
                MemberCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                CloseCashierCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                PostCloseCashierCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                OpenCashierCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                ExpenditureCubit(repository: sl())),
        BlocProvider(
            create: (context) =>
                AuthCubit(sl())),
        BlocProvider(
            create: (context) =>
                PrinterCubit(bluetooth: sl(),sharedPreferences: sl())),


        //for accounting
        BlocProvider(
          create: (context) => TransactionSummaryCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => EmployeeCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => TransactionReportInteractionCubit(employeeSharedPref: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => TransactionListCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => TransactionReportCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangeCubit(),
        ),
        BlocProvider(
          create: (context) => SalesReportCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => SalesProductReportCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangePurchaseCubit(),
        ),
        BlocProvider(
          create: (context) => TotalPurchaseCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => PurchaseListCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangeExpenditureCubit(),
        ),
        BlocProvider(
          create: (context) => TotalExpenditureCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangeProfitLossCubit(),
        ),
        BlocProvider(
          create: (context) => ProfitLossCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => ProfitLossDetailsCubit(),
        ),
        BlocProvider(
          create: (context) => PurchasedProductCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => DateRangeCashFlowCubit(),
        ),
        BlocProvider(
          create: (context) => CashFlowReportCubit(repository: accountingInjection()),
        ),
        BlocProvider(
          create: (context) => PendingAssetCubit(accountingInjection()),
        ),
        BlocProvider(
          create: (context) => ActiveAssetCubit(accountingInjection()),
        ),
        BlocProvider(
          create: (context) => SoldAssetCubit(repository:accountingInjection()),
        ),
        BlocProvider(
          create: (context) => AssetDepreciationCubit(repository:accountingInjection()),
        ),

        BlocProvider(
          create: (context) => DateRangeFinancialBalanceCubit(),
        ),
         BlocProvider(
          create: (context) => FinancialBalanceCubit(repository: accountingInjection()),
        ),
         BlocProvider(
          create: (context) => ServiceChargeCubit(repository: accountingInjection()),
        ),
         BlocProvider(
          create: (context) => ServiceChargeSettingCubit(repository: accountingInjection()),
        ),
         BlocProvider(
          create: (context) => TaxManagementCubit(repository: accountingInjection()),
        ),
         BlocProvider(
          create: (context) => TaxManagementSettingCubit(repository: accountingInjection()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _requestPermissions() async {
  // Request Bluetooth and Location Permissions
  PermissionStatus bluetoothStatus = await Permission.bluetooth.status;
  PermissionStatus locationStatus = await Permission.location.status;

  if (!bluetoothStatus.isGranted) {
    await Permission.bluetooth.request();
  }

  if (!locationStatus.isGranted) {
    await Permission.location.request();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'AK Solutions',
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor:
                  AppColors.primaryMain, // Warna kursor di seluruh aplikasi
              selectionColor: AppColors.primaryMain
                  .withOpacity(0.5), // Warna selection (highlight)
              selectionHandleColor:
                  AppColors.primaryMain, // Warna handle selection
            ),
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            primaryColor: AppColors.primaryMain,
            indicatorColor: AppColors.primaryMain,
   progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryMain, // Warna progress indicator
        ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
